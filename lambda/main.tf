# Creating IAM role so that Lambda service to assume the role and access other AWS services. 

resource "aws_iam_role" "lambda_role" {
  name               = "iam_role_lambda_function"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM policy for logging from a lambda

resource "aws_iam_policy" "lambda_logging" {

  name        = "iam_policy_lambda_logging_function"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListAccessPointsForObjectLambda",
                "s3:DeleteAccessPoint",
                "s3:DeleteAccessPointForObjectLambda",
                "logs:ListLogDeliveries",
                "s3:PutLifecycleConfiguration",
                "s3:DeleteObject",
                "s3:CreateMultiRegionAccessPoint",
                "logs:DescribeDestinations",
                "cloudwatch:DescribeInsightRules",
                "s3:GetBucketWebsite",
                "s3:GetMultiRegionAccessPoint",
                "s3:PutReplicationConfiguration",
                "s3:GetObjectAttributes",
                "s3:InitiateReplication",
                "s3:GetObjectLegalHold",
                "s3:GetBucketNotification",
                "cloudwatch:GetMetricStatistics",
                "s3:GetReplicationConfiguration",
                "s3:DescribeMultiRegionAccessPointOperation",
                "s3:PutObject",
                "s3:PutBucketNotification",
                "s3:CreateJob",
                "s3:PutBucketObjectLockConfiguration",
                "s3:GetStorageLensDashboard",
                "s3:GetLifecycleConfiguration",
                "s3:GetBucketTagging",
                "s3:GetInventoryConfiguration",
                "s3:GetAccessPointPolicyForObjectLambda",
                "s3:ListBucket",
                "cloudwatch:ListMetrics",
                "s3:AbortMultipartUpload",
                "s3:UpdateJobPriority",
                "s3:DeleteBucket",
                "cloudwatch:GetMetricWidgetImage",
                "s3:PutBucketVersioning",
                "s3:GetMultiRegionAccessPointPolicyStatus",
                "s3:ListBucketMultipartUploads",
                "s3:PutIntelligentTieringConfiguration",
                "s3:PutMetricsConfiguration",
                "logs:TestMetricFilter",
                "s3:GetBucketVersioning",
                "s3:GetAccessPointConfigurationForObjectLambda",
                "s3:PutInventoryConfiguration",
                "s3:GetStorageLensConfiguration",
                "s3:DeleteStorageLensConfiguration",
                "s3:GetAccountPublicAccessBlock",
                "s3:PutBucketWebsite",
                "s3:ListAllMyBuckets",
                "s3:PutBucketRequestPayment",
                "s3:PutObjectRetention",
                "cloudwatch:ListMetricStreams",
                "s3:CreateAccessPointForObjectLambda",
                "s3:GetBucketCORS",
                "s3:GetObjectVersion",
                "logs:GetLogRecord",
                "s3:PutAnalyticsConfiguration",
                "s3:PutAccessPointConfigurationForObjectLambda",
                "s3:GetObjectVersionTagging",
                "s3:PutStorageLensConfiguration",
                "s3:CreateBucket",
                "s3:GetStorageLensConfigurationTagging",
                "s3:ReplicateObject",
                "s3:GetObjectAcl",
                "s3:GetBucketObjectLockConfiguration",
                "s3:DeleteBucketWebsite",
                "s3:GetIntelligentTieringConfiguration",
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:ListDashboards",
                "s3:GetObjectVersionAcl",
                "s3:GetBucketPolicyStatus",
                "s3:GetObjectRetention",
                "s3:GetJobTagging",
                "s3:ListJobs",
                "logs:StopQuery",
                "s3:PutObjectLegalHold",
                "s3:PutBucketCORS",
                "s3:ListMultipartUploadParts",
                "s3:GetObject",
                "logs:DescribeExportTasks",
                "logs:GetQueryResults",
                "s3:DescribeJob",
                "s3:PutBucketLogging",
                "s3:GetAnalyticsConfiguration",
                "s3:GetObjectVersionForReplication",
                "s3:GetAccessPointForObjectLambda",
                "s3:CreateAccessPoint",
                "s3:GetAccessPoint",
                "s3:PutAccelerateConfiguration",
                "cloudwatch:GetMetricData",
                "s3:DeleteObjectVersion",
                "s3:GetBucketLogging",
                "s3:ListBucketVersions",
                "s3:RestoreObject",
                "s3:GetAccelerateConfiguration",
                "s3:GetObjectVersionAttributes",
                "s3:GetBucketPolicy",
                "logs:GetLogDelivery",
                "cloudwatch:DescribeAnomalyDetectors",
                "s3:PutEncryptionConfiguration",
                "s3:GetEncryptionConfiguration",
                "s3:GetObjectVersionTorrent",
                "s3:GetBucketRequestPayment",
                "s3:GetAccessPointPolicyStatus",
                "s3:GetObjectTagging",
                "s3:GetBucketOwnershipControls",
                "s3:GetMetricsConfiguration",
                "logs:DescribeQueryDefinitions",
                "logs:DescribeResourcePolicies",
                "s3:GetBucketPublicAccessBlock",
                "logs:DescribeQueries",
                "s3:GetMultiRegionAccessPointPolicy",
                "s3:GetAccessPointPolicyStatusForObjectLambda",
                "s3:ListAccessPoints",
                "s3:PutBucketOwnershipControls",
                "s3:DeleteMultiRegionAccessPoint",
                "s3:ListMultiRegionAccessPoints",
                "s3:UpdateJobStatus",
                "s3:GetBucketAcl",
                "s3:ListStorageLensConfigurations",
                "s3:GetObjectTorrent",
                "s3:GetBucketLocation",
                "s3:GetAccessPointPolicy",
                "s3:ReplicateDelete"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:CreateLogGroup",
                "logs:PutLogEvents",
                "logs:ListTagsLogGroup",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:DescribeSubscriptionFilters",
                "logs:StartQuery",
                "logs:GetLogEvents",
                "logs:DescribeMetricFilters",
                "logs:FilterLogEvents",
                "logs:GetLogGroupFields"
            ],
            "Resource": "arn:aws:logs:*:*:*:*"
        }
    ]
}
EOF
}

# Policy Attachment on the role.

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

# Generates an archive from content, a file, or a directory of files.

data "archive_file" "default" {
  type        = "zip"
  source_dir  = "${path.module}/function/"
  output_path = "${path.module}/public/nodejs.zip"
}

# Create a lambda function
# In terraform ${path.module} is the current directory.

resource "aws_lambda_function" "lambdafunc" {
  filename      = "${path.module}/public/nodejs.zip"
  function_name = "My_Lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.universal"
  runtime       = "nodejs14.x"
  depends_on    = [aws_iam_role_policy_attachment.policy_attach]
}
