abstract class ResouresNameMapping {
  static const ec2 =
      ResourceName(showName: "EC2", fieldValue: "AmazonEC2_Compute Instance");
  static const eks = ResourceName(showName: "EKS", fieldValue: "AmazonEC2_EKS");
  static const rds =
      ResourceName(showName: "RDS", fieldValue: "AmazonRDS_Database Instance");
  static const elastiCache = ResourceName(
      showName: "ElastiCache", fieldValue: "AmazonElastiCache_Cache Instance");

  static const computing = [ec2, eks];
  static const backing = [rds, elastiCache];
}

class ResourceName {
  final String showName;
  final String fieldValue;

  const ResourceName({required this.showName, required this.fieldValue});
}
