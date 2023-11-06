#' Title
#'
#' @param df.split data
#' @param iteration iteration
#' @param nc nunmber of cores (only for mc)
#' @param sub Subject
#' @param var1 variable 1
#' @param var2 variable 2
#' @param var3 variable 3
#' @param method split method, "mc", "fs", "od", "permuted"
#'
#' @return 返回分半的结果
#' @export 返回分半的结果

sh_tool <- function(df.split, iteration, nc, sub, var1, var2, var3, method) {
  result <- switch(
    method,
    "permuted" = permuted(df.split, iteration, nc, sub, var1, var2, var3),
    "mc" = mc(df.split, iteration, nc, sub, var1, var2, var3),
    "fs" = fsod(df.split, method, sub, var1, var2, var3),
    "od" = fsod(df.split, method, sub, var1, var2, var3),
    stop("Invalid indice argument")
  )
  return(result)
}
