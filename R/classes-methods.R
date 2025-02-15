

#### New method of summary for ForestTrain ####
#' @export
summary.ForestTrain <- function(object, ...){

  list(call = object$call,
       acc = object$acc,
       tp = object$tp,
       fp = object$fp,
       tn = object$tn,
       fn = object$fn
       )
}


#### New generic classify for ForestTrainParam ####
#' Classify parts of images as forest / non-forest
#'
#' Generic function classify dispatches methods according to the class of object Model.
#' A chosen method takes raster object data and classifies parts of it as 1- forest or 0- non-forest.
#'
#' Both classify.ForestTrainParam and classify.ForestTrainNonParam use parameter n_pts to split images
#' into square sub-frames of the size n_pts. Those sub-frames are classified independently and all pixels
#' from a sub-frame are tagged according to its classification result. When the image contained by data
#' is of dimensions that are not divisible by n_pts, it is truncated from the right and the bottom to
#' to make the largest divisible one. Thus, the result of classification can be of a different size than
#' the original image.
#'
#' @param Model trained model, e.g. by \code{\link{train}}
#' @param data raster object. \code{\link{read_data_raster}}
#' @param n_pts size of sub-frames into which data is split
#' @param parallel Boolean. Whether to use parallel setup
#' @param progress progress bar. Works only when parallel=FALSE. Could be set to 'text' or 'none'
#' @param ... additional parameters passed to methods
#'
#' @return a black-and-white image of the terrain data where white represents forest and black is for non-forest.
#'
#' @examples
#' library(deforestable)
#' n_pts <- 20
#'
#' # Choosing folders with training data
#' Forestdir <- system.file('extdata/Forest/', package = "deforestable")
#' Nonforestdir <- system.file('extdata/Non-forest/', package = "deforestable")
#'
#' #### Read the target image ####
#' tg_dir <- system.file('extdata/', package = "deforestable")
#' test_image <- read_data_raster('smpl_1.jpeg', dir = tg_dir)
#'
#'
#' # Simple training of the non-parametric model
#' Model_nonP_tr <- train(model='fr_Non-Param', Forestdir=Forestdir, Nonforestdir=Nonforestdir,
#'                        train_method='train', parallel=FALSE)
#'
#' res <- classify(data=test_image, Model=Model_nonP_tr,
#'                 n_pts=n_pts, parallel=FALSE, progress = 'text')
#'
#' tmp_d <- tempdir(); tmp_d
#' jpeg::writeJPEG(image=res, target=paste(tmp_d,'Model_nonP_tr.jpeg', sep='/'))
#'
#' @export
classify <- function(Model, ...) {
  UseMethod("classify")
}


#### New method classify for ForestTrain ####
# res <- classify(data=test_image, Model=ParModel, n_pts=10, parallel=FALSE, progress = 'text')
# jpeg::writeJPEG(image=res, target='Partest_im.jpeg')
#' @describeIn classify Method for the class ForestTrainParam
#' @export
classify.ForestTrainParam <- function(Model, data, n_pts, parallel=FALSE, progress = "text", ...){

    Param_classifier(rastData = data, n_pts=n_pts, Model = Model,
                     parallel = parallel, progress = progress)

}


# res <- classify(data=test_image, Model=ParModel, n_pts=10, parallel=FALSE, progress = 'text')
# jpeg::writeJPEG(image=res, target='NonPartest_im.jpeg')
#' @describeIn classify Method for the class ForestTrainNonParam
#' @export
classify.ForestTrainNonParam <- function(Model, data, n_pts, parallel=FALSE, progress = "text", ...){

    Nonparam_classifier(rastData = data, n_pts=n_pts, Model = Model,
                     parallel = parallel, progress = progress)

}


#' S3 class ForestTrain
#'
#'
#' Class ForestTrain is the main class to contain models for binary classification forest/non-forest.
#' It includes the following elements:
#'
#' @section Slots:
#'
#' | Element | Description |
#' | --- | --- |
#' | call | the function call with which it was created |
#' | tp | the number of true positives obtained during training |
#' | fp | the number of false positives obtained during training |
#' | tn | the number of true negatives obtained during training |
#' | fn | the number of false negatives obtained during training |
#' @md
#'
#' @details In most cases objects of this class are generated by function \code{\link{train}}.
#' Then, classification of terrain images is made by \code{\link{classify}}.
#' @name Class_ForestTrain
NULL


