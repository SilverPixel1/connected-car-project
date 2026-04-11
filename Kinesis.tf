#######################################################################################################################
#Build the Infrastructure for the Project: Kinesis Data Stream 
#######################################################################################################################

resource "aws_kinesis_stream" "sensor_data" {
    name             = "${var.project_name}-sensor-data-stream"
    shard_count      = 1
    retention_period = 24

    stream_mode_details {
      stream_mode = "PROVISIONED"
    }

    tags = {
      Name        = "${var.project_name}-sensor-data-stream"
      Environment = "Development"
      Project     = var.project_name
    }
}

# Output the Kinesis Stream ARN
output "kinesis_stream_arn" {
    value = aws_kinesis_stream.sensor_data.arn
}

output "kinesis_stream_name" {
  value = aws_kinesis_stream.sensor_data.name
}