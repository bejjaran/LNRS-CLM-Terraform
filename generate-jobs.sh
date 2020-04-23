#!/bin/bash
declare -A ADFS_ROLE_ARN_MAP=(
  [ris-bussvcs-dev]="arn:aws:iam::152186781777:role/ADFS-TAS-Terraform"
)

for accountPath in live/* ; do
  for regionPath in $accountPath/* ; do
    for lifecyclePath in $regionPath/* ; do
      if [ -f "$lifecyclePath/terragrunt.hcl" ]; then

        # Variables
        aws_account_alias=$(cut -d/ -f2 <<<${lifecyclePath})
        aws_region_name=$(cut -d/ -f3 <<<${lifecyclePath})
        aws_lifecycle_name=$(cut -d/ -f4 <<<${lifecyclePath})
        name=${aws_account_alias}/${aws_region_name}/${aws_lifecycle_name}

        # Build Roles
        declare -A ROLE_MAP=()
        ROLE_MAP["ris-bussvcs-dev"]="${ADFS_ROLE_ARN_MAP["ris-bussvcs-dev"]}"
        ROLE_MAP["$aws_account_alias"]="${ADFS_ROLE_ARN_MAP["$aws_account_alias"]}"

        declare -a adfs_profiles=();
        declare -a adfs_role_arns=();
        for adfs_profile in "${!ROLE_MAP[@]}"
        do
          adfs_profiles+=( "${adfs_profile}" )
          adfs_role_arns+=( "${ROLE_MAP[$adfs_profile]}" )
        done

        # Build Output
cat << EOF
build-${name}:
  extends: .build
  variables:
    ROOT_DIR: '${lifecyclePath}'
    AWS_PROFILE: '${aws_account_alias}'
  before_script:
    - export ADFS_PROFILE=(
$(printf "        '%s'\n" "${adfs_profiles[@]}")
      )
    - export ADFS_ROLE_ARN=(
$(printf "        '%s'\n" "${adfs_role_arns[@]}")
      )
    - export TF_VAR_mssql_admin_username=\$mssql_username
    - export TF_VAR_mssql_admin_password=\$mssql_password
  only:
    refs:
      - merge_requests
      - master
    changes:
      - ${lifecyclePath}/**/*
      - live/*.hcl
      - modules/**/*

${name}:
  extends: .deploy
  variables:
    ROOT_DIR: '${lifecyclePath}'
    AWS_PROFILE: '${aws_account_alias}'
  before_script:
    - export ADFS_PROFILE=(
$(printf "        '%s'\n" "${adfs_profiles[@]}")
      )
    - export ADFS_ROLE_ARN=(
$(printf "        '%s'\n" "${adfs_role_arns[@]}")
      )
  dependencies: [build-${name}]
  environment:
    name: ${name}
  only:
    refs:
      - master
    changes:
      - ${lifecyclePath}/**/*
      - live/*.hcl
      - modules/**/*

EOF
      fi
    done
  done
done