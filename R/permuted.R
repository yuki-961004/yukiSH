#' Permuted Split Half
#'
#' @param df.split A list of split datasets
#' @param iteration Number of iterations
#' @param nc Number of CPU threads to use
#' @param sub Column identifying the subject
#' @param vars Variables to be considered
#'
#' @return Returns the result of the permuted split
#' @export

permuted <- function(df.split, iteration, nc, sub, vars) {
  # Scientific notation
  base::options(scipen = 999)

  # Ensure vars is a vector of column names
  if (!is.character(vars)) {
    stop("vars should be a character vector of column names.")
  }

  # Check if all vars exist in the dataframe
  if (!all(vars %in% colnames(df.split))) {
    stop("One or more columns in vars do not exist in the dataframe.")
  }

  # Combine sub and vars to create the list of factors for stratification
  stratify_vars <- c(sub, vars)

  # Convert columns to factors and create a list for splitting
  split_data <- base::split(
    x = df.split,
    f = base::lapply(df.split[stratify_vars], as.factor)
  )

  # Initialize a vector to store the Pearson correlation coefficients
  split_list <- vector("list", iteration)

  # Initialize the parallel backend
  doParallel::registerDoParallel(nc)

  # declare j variable
  j <- 0

  # Run the for loop in parallel
  split_list <- foreach::foreach(j = 1:iteration, .combine = "c") %dopar% {
    set.seed(122+j)
    # Initialize empty lists to store the split-half data sets
    str_half_split_1 <- list()
    str_half_split_2 <- list()

    # Calculate the split-half reliability for each group
    str_half_split <- base::lapply(split_data, function(x) {

      # Remove rows with missing values
      data <- x[complete.cases(x),]

      # Permute the rows of the data and split it into two halves
      permuted_data <- data[sample(nrow(data)),]
      half_split_1 <- permuted_data[1:floor(nrow(permuted_data)/2),]
      half_split_2 <- permuted_data[(floor(nrow(permuted_data)/2)+1):nrow(permuted_data),]

      # Get the minimum number of rows between the two data sets
      min_rows <- min(nrow(half_split_1), nrow(half_split_2))

      # Subset both data sets to use the same number of rows
      half_split_1 <- half_split_1[1:min_rows,]
      half_split_2 <- half_split_2[1:min_rows,]

      # Return the split-half data sets
      return(list(half_split_1, half_split_2))
    })

    # Combine the split-half data sets from all groups
    str_half_split_1 <- base::do.call(rbind, lapply(str_half_split, "[[", 1))
    str_half_split_2 <- base::do.call(rbind, lapply(str_half_split, "[[", 2))

    # Return the split-half data sets
    return(list(str_half_split_1, str_half_split_2))
  }

  # Stop the parallel backend
  doParallel::stopImplicitCluster()

  # Combine every two sublists into a single list and create a new list of length iteration
  combined_list <- vector("list", iteration)
  for (i in 1:iteration) {
    combined_list[[i]] <- list(split_list[[2*i-1]], split_list[[2*i]])
  }

  return(combined_list)
}
