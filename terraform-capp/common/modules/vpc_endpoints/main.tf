resource "aws_vpc_endpoint" "endpoint" {
  count = try(var.endpoint_creation, false) == true ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = var.service_name
  auto_accept         = try(var.auto_accept_connection, true)
  private_dns_enabled = try(var.private_dns_enabled, true)
  route_table_ids = var.gateway_only_route_table_ids
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  vpc_endpoint_type   = var.endpoint_type
}