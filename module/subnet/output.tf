output "prvsub1" {
    value = aws_subnet.k8s-proj-privsub1.id 
}

output "prvsub2" {
    value = aws_subnet.k8s-proj-privsub2.id 
}

output "prvsub3" {
    value = aws_subnet.k8s-proj-privsub3.id 
}


output "pubsub1" {
  value = aws_subnet.k8s-proj-pubsub1.id
}

output "pubsub2" {
  value = aws_subnet.k8s-proj-pubsub2.id
}

output "pubsub3" {
  value = aws_subnet.k8s-proj-pubsub3.id
}

output "prvsub-id" {
  value = [aws_subnet.k8s-proj-privsub1.id, aws_subnet.k8s-proj-privsub2.id, aws_subnet.k8s-proj-privsub3.id]
}

# output "pubsub-id" {
#   value = [aws_subnet.k8s-proj-pubsub1.id, aws_subnet.k8s-proj-pubsub2.id, aws_subnet.k8s-proj-pubsub3.id]
# }