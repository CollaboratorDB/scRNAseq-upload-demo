library(scRNAseq)
everything <- listDatasets()

library(alabaster)
library(CollaboratorDB)

dirname <- "scRNAseq"
dir.create(dirname)

bplapply(seq_len(nrow(everything)), function(i) {
    call <- everything$Call[i]
    name <- sub("\\(\\)$", "", call)

    success <- file.path(dirname, paste0(name, ".OK"))
    if (!file.exists(success)) {
        unlink(file.path(dirname, name), recursive=TRUE)
        x <- eval(parse(text=call))
        saveObject(x, dirname, name)
        write(file=success, character(0))
    }
})
