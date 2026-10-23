
#!/bin/bash
set -u

full_name="George Adimowei Epebifie"
aws_region="us-east-1"
s3_bucket_name="pravin-portfolio-oweigeorge-us-east-1-577638383122-us-east-1-an"
rds_instance_id="database-1"
ebs_volume_id="vol-038a8cd2e94d92af3"

base_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
report_dir="$base_dir/reports"
report_file="$report_dir/aws-audit-report.txt"

checks=(
    check_s3_public_access
    check_ssh_open_to_world
    check_mysql_open_to_world
    check_rds_public_access
    check_ebs_encryption
)

pass_count=0
warning_count=0
failure_count=0

mkdir -p "$report_dir"
: > "$report_file"

write_line() {
    echo "$1" | tee -a "$report_file"
}

mark_pass() {
    write_line "[PASS] $1"
    pass_count=$((pass_count + 1))
}

mark_warning() {
    write_line "[WARN] $1"
    warning_count=$((warning_count + 1))
}

mark_failure() {
    write_line "[FAIL] $1"
    failure_count=$((failure_count + 1))
}

print_header() {
    write_line "========================================"
    write_line "AWS Security and Cost Audit Report"
    write_line "========================================"
    write_line "Full Name: $full_name"
    write_line "Timestamp: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
    write_line "AWS Region: $aws_region"
    write_line "S3 Bucket: $s3_bucket_name"
    write_line "RDS Instance: $rds_instance_id"
    write_line "EBS Volume: $ebs_volume_id"
    write_line ""
}

check_s3_public_access() {
    local block_acls
    local ignore_acls

    block_acls=$(aws s3api get-public-access-block \
        --bucket "$s3_bucket_name" \
        --query 'PublicAccessBlockConfiguration.BlockPublicAcls' \
        --output text 2>/dev/null) || {
            mark_warning "Could not retrieve BlockPublicAcls for S3 bucket '$s3_bucket_name'"
            return
        }

    ignore_acls=$(aws s3api get-public-access-block \
        --bucket "$s3_bucket_name" \
        --query 'PublicAccessBlockConfiguration.IgnorePublicAcls' \
        --output text 2>/dev/null) || {
            mark_warning "Could not retrieve IgnorePublicAcls for S3 bucket '$s3_bucket_name'"
            return
        }

    if [ "$block_acls" = "True" ] && [ "$ignore_acls" = "True" ]; then
        mark_pass "S3 bucket '$s3_bucket_name' blocks and ignores public ACLs"
    else
        mark_failure "S3 bucket '$s3_bucket_name' does not fully block public ACLs (BlockPublicAcls=$block_acls, IgnorePublicAcls=$ignore_acls)"
    fi
}

check_ssh_open_to_world() {
    local open_rule_count

    open_rule_count=$(aws ec2 describe-security-group-rules \
        --region "$aws_region" \
        --query "length(SecurityGroupRules[?IsEgress==\`false\` && IpProtocol=='tcp' && FromPort==\`22\` && ToPort==\`22\` && CidrIpv4=='0.0.0.0/0'])" \
        --output text 2>/dev/null) || {
            mark_warning "Could not check security group rules for public SSH access"
            return
        }

    if [ "$open_rule_count" -gt 0 ] 2>/dev/null; then
        mark_failure "$open_rule_count security group rule(s) allow SSH (port 22) from 0.0.0.0/0"
    else
        mark_pass "No security group rule allows SSH (port 22) from 0.0.0.0/0"
    fi
}

check_mysql_open_to_world() {
    local open_rule_count

    open_rule_count=$(aws ec2 describe-security-group-rules \
        --region "$aws_region" \
        --query "length(SecurityGroupRules[?IsEgress==\`false\` && IpProtocol=='tcp' && FromPort==\`3306\` && ToPort==\`3306\` && CidrIpv4=='0.0.0.0/0'])" \
        --output text 2>/dev/null) || {
            mark_warning "Could not check security group rules for public MySQL access"
            return
        }

    if [ "$open_rule_count" -gt 0 ] 2>/dev/null; then
        mark_failure "$open_rule_count security group rule(s) allow MySQL (port 3306) from 0.0.0.0/0"
    else
        mark_pass "No security group rule allows MySQL (port 3306) from 0.0.0.0/0"
    fi
}

check_rds_public_access() {
    local publicly_accessible

    publicly_accessible=$(aws rds describe-db-instances \
        --db-instance-identifier "$rds_instance_id" \
        --region "$aws_region" \
        --query 'DBInstances[0].PubliclyAccessible' \
        --output text 2>/dev/null) || {
            mark_warning "Could not determine public accessibility for RDS instance '$rds_instance_id'"
            return
        }

    if [ "$publicly_accessible" = "False" ]; then
        mark_pass "RDS instance '$rds_instance_id' is not publicly accessible"
    elif [ "$publicly_accessible" = "True" ]; then
        mark_failure "RDS instance '$rds_instance_id' is publicly accessible"
    else
        mark_warning "Could not determine public accessibility for RDS instance '$rds_instance_id'"
    fi
}

check_ebs_encryption() {
    local encrypted
    local volume_state

    encrypted=$(aws ec2 describe-volumes \
        --volume-ids "$ebs_volume_id" \
        --region "$aws_region" \
        --query 'Volumes[0].Encrypted' \
        --output text 2>/dev/null) || {
            mark_warning "Could not retrieve encryption status for EBS volume '$ebs_volume_id'"
            return
        }

    if [ "$encrypted" = "True" ]; then
        volume_state=$(aws ec2 describe-volumes \
            --volume-ids "$ebs_volume_id" \
            --region "$aws_region" \
            --query 'Volumes[0].State' \
            --output text 2>/dev/null) || {
                mark_warning "Could not retrieve state for EBS volume '$ebs_volume_id'"
                return
            }

        mark_pass "EBS volume '$ebs_volume_id' is encrypted (State=$volume_state)"

    elif [ "$encrypted" = "False" ]; then
        mark_failure "EBS volume '$ebs_volume_id' is not encrypted"

    else
        mark_warning "Could not determine encryption status for EBS volume '$ebs_volume_id' (Encrypted=$encrypted)"
    fi
}

print_summary() {
    local overall_status
    local script_exit_code

    if [ "$failure_count" -gt 0 ]; then
        overall_status="FAIL"
        script_exit_code=2
    elif [ "$warning_count" -gt 0 ]; then
        overall_status="WARN"
        script_exit_code=1
    else
        overall_status="HEALTHY"
        script_exit_code=0
    fi

    write_line ""
    write_line "Summary:"
    write_line "PASS: $pass_count"
    write_line "WARN: $warning_count"
    write_line "FAIL: $failure_count"
    write_line "Overall Status: $overall_status"
    write_line "Script Exit Code: $script_exit_code"
    write_line "Report File: $report_file"

    return "$script_exit_code"
}

print_header

for check_function in "${checks[@]}"; do
    "$check_function"
done

print_summary
exit $?
