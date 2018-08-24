{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
       "Effect":"Allow",
       "Action":[
          "athena:*"
       ],
       "Resource":[
          "*"
       ]
    },
    {
       "Effect":"Allow",
       "Action":[
          "glue:GetTable",
          "glue:GetPartition",
          "glue:GetPartitions"
       ],
       "Resource":[
          "*"
       ]
    },
    {
       "Effect":"Allow",
       "Action":[
          "s3:GetObject",
          "s3:ListBucket"
       ],
       "Resource":[
          "${in_bucket_arn}*"
       ]
    },
    {
       "Effect":"Allow",
       "Action":[
          "s3:PutObject"
       ],
       "Resource":[
          "${out_bucket_arn}*"
       ]
    }
  ]
}
