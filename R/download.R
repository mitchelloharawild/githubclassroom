clone_assignments <- function(path, assignment, organisation) {
  git_urls <- search_assignments(assignment, organisation)
  user <- stringr::str_match(git_urls, glue::glue("{assignment}-(.+)\\.git$"))[,2]
  repo_path <- file.path(path, user)
  p <- progressr::progressor(along = git_urls, label = "Cloning assignment repositories...")
  for(i in seq_along(git_urls)) {
    git2r::clone(git_urls[i], repo_path[i], progress = FALSE,
                 credentials = git2r::cred_token())
    p(user[i])
  }
}

search_assignments <- function(assignment, organisation) {
  result <- gh::gh(
    endpoint = "/search/repositories",
    q = glue::glue("{assignment} in:name org:{organisation}"),
    per_page = Inf)
  cli::cli_alert_success("Found {result$total_count} {assignment} assignments from {organisation}.")
  if(result$incomplete_results) {
    cli::cli_alert_danger("Careful, the search results are incomplete!")
  }
  vapply(result$items, `[[`, character(1L), i = "clone_url")
}
