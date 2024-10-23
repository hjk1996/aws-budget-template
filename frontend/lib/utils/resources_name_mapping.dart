abstract class ResouresNameMapping {
  static const ec2 = ResourceSetting(
    showName: "EC2",
    fieldValue: "AmazonEC2_Compute Instance",
    columnsToDisplay: [
      "instanceFamily",
      "instanceType",
      "operatingSystem",
      "vcpu",
      "memory",
      "unit",
      "pricePerUnit",
    ],
    sortOrder: [
      "instanceFamily",
      "instanceType",
      "operatingSystem",
      "vcpu",
      "memory",
      "pricePerUnit",
    ],
  );
  static const eks = ResourceSetting(
    showName: "EKS",
    fieldValue: "AmazonEC2_EKS",
    columnsToDisplay: [
      "operatingSystem"
          "unit",
      "pricePerUnit",
      "vcpu",
      "memory"
    ],
    sortOrder: [
      "vcpu",
      "memory",
      "pricePerUnit",
    ],
  );
  static const rds = ResourceSetting(
    showName: "RDS",
    fieldValue: "AmazonRDS_Database Instance",
    columnsToDisplay: [
      "operatingSystem"
          "unit",
      "pricePerUnit",
      "vcpu",
      "memory"
    ],
    sortOrder: [
      "vcpu",
      "memory",
      "pricePerUnit",
    ],
  );
  static const elastiCache = ResourceSetting(
    showName: "ElastiCache",
    fieldValue: "AmazonElastiCache_Cache Instance",
    columnsToDisplay: [
      "operatingSystem"
          "unit",
      "pricePerUnit",
      "vcpu",
      "memory"
    ],
    sortOrder: [
      "vcpu",
      "memory",
      "pricePerUnit",
    ],
  );
  static const msk = ResourceSetting(
    showName: "MSK",
    fieldValue: "AmazonMSK_Something",
    columnsToDisplay: [
      "operatingSystem"
          "unit",
      "pricePerUnit",
      "vcpu",
      "memory"
    ],
    sortOrder: [
      "vcpu",
      "memory",
      "pricePerUnit",
    ],
  );

  static const computing = [ec2, eks];
  static const backing = [rds, elastiCache];
}

class ResourceSetting {
  final String showName;
  final String fieldValue;
  final List<String> columnsToDisplay;
  final List<String> sortOrder;

  const ResourceSetting({
    required this.showName,
    required this.fieldValue,
    required this.columnsToDisplay,
    required this.sortOrder,
  });
}
