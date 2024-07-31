# yukiSH
This function splits your data into two halves using one of four methods (returns a list):

* First-Second Split Half  
-- `method = "fs"` : [First -- Middle] [Middle -- Last]
* Odd-Even Split Half  
-- `method = "od"` : [1, 3, 5, 7, ...] [2, 4, 6, 8, ...]
* Permuted Split Half  
-- `method = "permuted"` : [Random sampling without replacement]
* Monte Carlo Split Half  
-- `method = "mc"` : [Random sampling with replacement]

## How to cite 
Liu, Z., Hu, M., Zheng, Y. R., Sui, J., & Chuan-Peng, H. (2023). A Multiverse Assessment of the Reliability of the Perceptual Matching Task as a Measurement of the Self-prioritization Effect (Preprint). *Open Science Framework* https://doi.org/10.31234/osf.io/g6uap
## Why Build This Package

The output from `splithalfr` is not well-suited for further calculations.   
Therefore, I separated the process of calculating split-half reliability into two distinct steps: first, splitting the data, and then calculating the reliability.   
This approach allows you to perform additional analyses on the split halves, such as Drift Diffusion Model (DDM).

`yukiSH` is used for splitting the dataset, while   
`yukiBP` is used for calculating the correlation coefficient.  

### NAMESPACE
```{r}
import("dplyr", "foreach", "parallel", "doParallel", "iterators")
importFrom("stats", "complete.cases")
importFrom("dplyr", "sample_n")
export("sh_tool")
```

## Install
```{r}
devtools::install_github("yuki-961004/yukiSH") 
```

## Examples
### Generate the dataset
```{r simulated data}
SMT <- base::expand.grid(
  Subject = 1:10,
  Matching = c("Matching", "Nonmatching"),
  Identity = c("Self", "Friend", "Stranger"),
  Session = 1:3
) %>%
  dplyr::slice(rep(1:n(), each = 60)) %>%
  dplyr::mutate(
    RT_ms = sample(200:1500, n(), replace = TRUE),
    RT_sec = RT_ms / 1000,
    ACC = sample(0:1, n(), replace = TRUE)  # Adding ACC column
  ) %>%
  dplyr::arrange(Subject, Session, Matching, Identity)
```

### Create a NULL list to store the output 
```{r Split Half List}
shl <- list(list(), list(), list(), list())
names(shl)[1] <- "First-Second"
names(shl)[2] <- "Odd-Even"
names(shl)[3] <- "Permuted"
names(shl)[4] <- "Monte Carlo"
```

### First-Second
```{r First-Second SHR}
shl[[1]] <- yukiSH::sh_tool(
  df.split = SMT, 
  method = "fs", 
  sub = "Subject", 
  vars = c("Matching", "Identity", "Session")
)
Half_1 <- shl[[1]][[1]]
Half_2 <- shl[[1]][[2]]
```

### Odd-Even
```{r Odd-Even SHR}
shl[[2]] <- yukiSH::sh_tool(
  df.split = SMT, 
  method = "od", 
  sub = "Subject", 
  vars = c("Matching", "Identity", "Session")
)
Half_1 <- shl[[1]][[1]]
Half_2 <- shl[[1]][[2]]
```

### Permuted
```{r Permuted SHR}
shl[[3]] <- yukiSH::sh_tool(
  df.split = SMT, 
  method = "permuted", 
  sub = "Subject", 
  vars = c("Matching", "Identity", "Session"),
  iteration = 10, 
  nc = parallel::detectCores()
) 

# iteration = 1
Half_1 <- shl[[1]][[1]]
Half_2 <- shl[[1]][[2]]
# iteration = 2
Half_1 <- shl[[2]][[1]]
Half_2 <- shl[[2]][[2]]
# iteration = 3
Half_1 <- shl[[3]][[1]]
Half_2 <- shl[[3]][[2]]
# iteration = ...
```

### Monte Carlo
```{r Monte Carlo SHR}
shl[[3]] <- yukiSH::sh_tool(
  df.split = SMT, 
  method = "mc", 
  sub = "Subject", 
  vars = c("Matching", "Identity", "Session"),
  iteration = 10, 
  nc = parallel::detectCores()
) 

# iteration = 1
Half_1 <- shl[[1]][[1]]
Half_2 <- shl[[1]][[2]]
# iteration = 2
Half_1 <- shl[[2]][[1]]
Half_2 <- shl[[2]][[2]]
# iteration = 3
Half_1 <- shl[[3]][[1]]
Half_2 <- shl[[3]][[2]]
# iteration = ...
```
