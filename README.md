# yukiSH
a splithalf tool SPMT datasets

我的第一个R包

用四种方法来对一个数据集进行分半
四种方法是first-secon，odd-even，permuted和Monte Carlo

依赖以下这些包
data.table, foreach, parallel, doParallel
你得提前安装，我没写检查你是否安装了这些包的代码

以下是示例

## Create NULL list
```{r Split Half List}
shl <- list(list(), list(), list(), list())
names(shl)[1] <- "First-Second"
names(shl)[2] <- "Odd-Even"
names(shl)[3] <- "Permuted"
names(shl)[4] <- "Monte Carlo"
```

## First-Second
```{r First-Second SHR}
shl[[1]] <- yukiSH::sh_tool(df.split = df[[1]], method = "fs", 
                            sub = "Subject", var1 = "Matching", var2 = "Identity", var3 = "Session")
```
## Odd-Even
```{r Odd-Even SHR}
shl[[2]] <- yukiSH::sh_tool(df.split = df[[1]], method = "od", 
                            sub = "Subject", var1 = "Matching", var2 = "Identity", var3 = "Session")
```
## Permuted
```{r Permuted SHR}
shl[[3]] <- yukiSH::sh_tool(df.split = df[[1]], method = "permuted", 
                            sub = "Subject", var1 = "Matching", var2 = "Identity", var3 = "Session")
```
## Monte Carlo
```{r Monte Carlo SHR}
shl[[4]] <- yukiSH::sh_tool(df.split = df[[1]], method = "mc", 
                            sub = "Subject", var1 = "Matching", var2 = "Identity", var3 = "Session",
                            iteration = 50, nc = 16)
```

代码很简陋，估计是必须需要三个变量才能运行，如果你没有那么多自变量，你可以新建一个变量，然后全部设为1
