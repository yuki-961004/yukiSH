#' irst-Second & Odd-Even Split Half
#'
#' @param df.split A list of split datasets
#' @param method The method used for splitting
#' @param sub Subject identifier
#' @param vars Variables to be considered
#'
#' @return Returns the result of the split
#' @export

fsod <- function(df.split, method, sub, vars) {
  # Set the seed to fix the output value
  set.seed(123)

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
    f = lapply(df.split[stratify_vars], as.factor)
  )

  # Initialize empty lists to store the split-half data sets
  str_half_split_1 <- list()
  str_half_split_2 <- list()

  # Calculate the split-half reliability for each group
  str_half_split <- base::lapply(split_data, function(x) {
    # Remove rows with missing values
    data <- x[complete.cases(x),]

    if (method == "fs") {
      # Split the data into two subsets using a first-second split
      half_split_1 <- data[1:floor(nrow(data)/2),]
      half_split_2 <- data[(floor(nrow(data)/2)+1):nrow(data),]
    } else {
      # Create a vector of row indices
      row_indices <- seq(1, nrow(data))
      # Select the odd-numbered indices for one split-half group
      half_split_1 <- data[row_indices %% 2 == 1, ]
      # Select the even-numbered indices for the other split-half group
      half_split_2 <- data[row_indices %% 2 == 0, ]
    }

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

  split_list <- list(str_half_split_1, str_half_split_2)

  return(split_list)
}
