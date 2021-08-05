# DocumentDB cluster

resource "aws_docdb_cluster" "pixelapp_docdb" {
  cluster_identifier  = var.docdb.cluster_identifier
  engine              = var.docdb.engine
  availability_zones  = data.aws_availability_zones.available.names
  master_username     = var.docdb_master_username
  master_password     = var.docdb_master_password
  tags                = var.tags_for_app
  skip_final_snapshot = true
}


# DocumentDB instance

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.docdb.instance_count
  identifier         = var.docdb.instances_identifier
  cluster_identifier = aws_docdb_cluster.pixelapp_docdb.id
  instance_class     = var.docdb.instance_class
  tags               = var.tags_for_app
}