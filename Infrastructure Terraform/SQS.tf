
# Kinesis wird mit SQS ersetzt, das es für das HomeLab kostengünstiger und einfacher zu implementieren ist.


resource "aws_sqs_queue" "sensor_queue" {
  name = "${var.project_name}-sensor-data-queue"

  visibility_timeout_seconds = 30
    message_retention_seconds  = 86400

    tags = {
      Project = var.project_name
      Environment ="Developement"
    }
  
}