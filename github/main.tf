resource "github_repository" "test-repo" {
    name = "mytestrepo"
    visibility = "public"
  
}

resource "github_branch" "development" {
  repository = "mytestrepo"
  branch     = "development"

  depends_on = [ github_repository.test-repo ]
}
