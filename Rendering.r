# 랜더링
if (TRUE) {
  library(rmarkdown)
  
  render("House_Pred.rmd", md_document())
  
  render("House_Pred.rmd", md_document(variant = "markdown_github"))
}
