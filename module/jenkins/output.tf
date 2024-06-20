output "jenkins_private_ip"{
    value = aws_instance.Jenkins_Server.private_ip
}

output "jenkins_dns"{
    value = aws_elb.jenkins_lb.dns_name
}

output "jenkins_zoneid"{
    value = aws_elb.jenkins_lb.zone_id
}