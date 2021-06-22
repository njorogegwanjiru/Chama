class Project {
  final String projectId;
  final String projectName;
  final int totalAmountRaised;
  Project({this.projectId, this.projectName, this.totalAmountRaised});

  factory Project.fronJson(dynamic json) {
    return Project(
        projectId: json['projectId'],
        projectName: json['projectName'],
        totalAmountRaised: json['totalAmountRaised']);
  }
}
