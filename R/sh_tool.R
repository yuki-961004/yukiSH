#' Function for Splitting Cognitive Experiment Datasets
#'
#' @param df.split Dataset to be split
#' @param iteration Number of iterations. Required only for Monte Carlo and Permuted split half
#' @param nc nunmber of cores Required only for Monte Carlo and Permuted split half
#' @param sub Subject ID
#' @param vars Stratification variables, i.e., all variables in your study
#' @param method Splitting method, choose one from the following four: 'mc', 'fs', 'od', 'permuted
#'
#' @return Returns the result of the split
#' @export
#'
sh_tool <- function(df.split, iteration, nc, sub, vars, method) {
  result <- switch(
    method,
    "permuted" = permuted(df.split, iteration, nc, sub, vars),
    "mc" = mc(df.split, iteration, nc, sub, vars),
    "fs" = fsod(df.split, method, sub, vars),
    "od" = fsod(df.split, method, sub, vars),
    stop("Invalid indice argument")
  )
  return(result)
}
