library(scRNAseq)
ExperimentHub::setExperimentHubOption("CACHE", "hub")
everything <- listDatasets()

library(alabaster)
library(CollaboratorDB)

dirname <- "scRNAseq"
dir.create(dirname)
sucname <- "OK"
dir.create(sucname)

for (i in seq_len(nrow(everything))) {
    call <- everything$Call[i]
    name <- sub("\\(.*\\)$", "", call)

    success <- file.path(sucname, name)
    if (!file.exists(success)) {
        unlink(file.path(dirname, name), recursive=TRUE)
        unlink(file.path(dirname, paste0(name, ".json")), recursive=TRUE)

        x <- eval(parse(text=call))

        # Now, time for the hellish disentanglement of metadata.
        help <- as.character(utils:::.getHelpFile(as.character(help(name))))
        is.finish <- which(help == "}")

        is.title <- which(help == "\\title")
        title <- paste(help[(is.title + 2) : (min(is.finish[is.finish > is.title]) - 1)], collapse=" ")

        is.desc <- which(help == "\\description")
        desc <- paste(help[(is.desc + 2) : (min(is.finish[is.finish > is.desc]) - 1)], collapse=" ")

        is.geo <- grepl("GSE[0-9]+", help)
        geo <- sub(".*(GSE[0-9]+).*", "\\1", help[is.geo])
        is.ae <- grepl("E-MTAB-[0-9]+", help)
        ae <- sub(".*(E-MTAB-[0-9]+).*", "\\1", help[is.ae])

        origins <- c(lapply(geo, function(x) list(source="GEO", id=x)), lapply(ae, function(x) list(source="ArrayExpress", id=x)))

        # Data-specific clean-ups.
        if (name == "FletcherOlfactoryData") {
            colData(x) <- colData(x)[,!duplicated(colnames(colData(x)))]
        }

        x <- annotateObject(x,
            title=title,
            description=desc,
            species=everything$Taxonomy[i],
            genome=list(), # not in the metadata.
            authors="Aaron Lun <infinite.monkeys.with.keyboards@gmail.com>",
            origin=origins
        )

        saveObject(x, dirname, name)
        write(file=success, character(0))

        rm(x)
        gc()
    }
}
