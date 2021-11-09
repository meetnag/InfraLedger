class Project {
  var projects;

  Project({
    this.projects,
  });

  Map<String, dynamic> toMap(Project cat) {
    Map<String, dynamic> callMap = Map();
    callMap["projects"] = cat.projects;
    return callMap;
  }

  Project.fromMap(Map callMap) {
    this.projects = callMap["projects"];
  }
}
