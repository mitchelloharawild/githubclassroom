#' Clone assignment repositories from GitHub Classroom
#'
#' \lifecycle{maturing}
#'
#' @param path The directory to clone repositories into. Each repository will be
#'   added in a subdirectory based on the student's GitHub username.
#' @param assignment The assignment to clone (the prefix of the assignment
#'   repository name on GitHub).
#' @param organisation The GitHub Classroom organisation name.
#'
#' @examples
#'
#' \dontrun{
#' clone_assignments(
#'   "~/teaching/ETC5523/assignment_1",
#'   assignment = "take-home-assignment",
#'   organisation = "etc5523-2020"
#'  )
#' }
#'
#' @export
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
