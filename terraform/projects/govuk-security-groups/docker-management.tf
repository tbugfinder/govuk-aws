#
# == Manifest: Project: Security Groups: docker-management
#
# The docker management needs to be accessible on ports:
#   - 2379
#   - 2380
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_docker_management_id
# sg_docker_management_etcd_elb_id

resource "aws_security_group" "docker_management" {
  name        = "${var.stackname}_docker_management_access"
  vpc_id      = "${data.terraform_remote_state.govuk_vpc.vpc_id}"
  description = "Access to the docker_management host from its ELB"

  tags {
    Name = "${var.stackname}_docker_management_access"
  }
}

resource "aws_security_group_rule" "allow_docker_management_etcd_elb_in" {
  type      = "ingress"
  from_port = 2379
  to_port   = 2379
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.docker_management.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.docker_management_etcd_elb.id}"
}

resource "aws_security_group_rule" "allow_docker_management_to_docker_management" {
  type      = "ingress"
  from_port = 2380
  to_port   = 2380
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.docker_management.id}"
  source_security_group_id = "${aws_security_group.docker_management.id}"
}

resource "aws_security_group" "docker_management_etcd_elb" {
  name        = "${var.stackname}_docker_management_etcd_elb_access"
  vpc_id      = "${data.terraform_remote_state.govuk_vpc.vpc_id}"
  description = "Access the docker_management etcd ELB"

  tags {
    Name = "${var.stackname}_docker_management_etcd_elb_access"
  }
}

resource "aws_security_group_rule" "allow_management_to_docker_management_etcd_elb" {
  type      = "ingress"
  from_port = 2379
  to_port   = 2379
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.docker_management_etcd_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_docker_management_etcd_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.docker_management_etcd_elb.id}"
}
