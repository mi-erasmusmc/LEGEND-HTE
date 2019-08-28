getResults <- function(targ,
                       comp,
                       strat,
                       est,
                       db,
                       ind,
                       anal){
  
  res <- list()
  
  reference <- readRDS("data/map.rds")
  stratOutcomeId <- reference$idNumber[reference$label == strat]
  estOutcomeId <- reference$idNumber[reference$label == est]
  
  res$relative <- readRDS("data/relative.rds") %>%
    filter(target == targ & comparator == comp &
             stratOutcome == stratOutcomeId & estOutcome == estOutcomeId &
             database == db & indication == ind & analysis == anal)
  
  res$absolute <- readRDS("data/absolute.rds") %>%
    filter(target == targ & comparator == comp &
             stratOutcome == stratOutcomeId & estOutcome == estOutcomeId &
             database == db & indication == ind & analysis == anal)
  
  res$cases <- readRDS("data/cases.rds") %>%
    filter(target == targ & comparator == comp &
             stratOutcome == stratOutcomeId & estOutcome == estOutcomeId &
             database == db & indication == ind & analysis == anal)
  
  return(res)
  
}


combinedPlot <- function(cases,
                         relative,
                         absolute){
  
  cases <-  reshape::melt(cases,
                          id.vars = c("riskStratum"),
                          measure.vars = c("casesComparator", "casesTarget"))
  
  casesPlot <- ggplot2::ggplot(data = cases, ggplot2::aes(x = riskStratum, y = value*100)) +
    ggplot2::geom_bar(stat = 'identity', position = ggplot2::position_dodge(), 
                      ggplot2::aes(fill = variable), width = .5)+
    ggplot2::xlab('Risk Stratum') +
    ggplot2::ylab('Outcome Rate (%)') +
    ggplot2::geom_hline(yintercept = 0, size = .8) +
    # ggplot2::coord_cartesian(ylim = ylimCases) +
    ggplot2::scale_fill_brewer(palette="Paired") +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.title = ggplot2::element_blank(),
                   axis.title.x = ggplot2::element_blank(),
                   axis.text.x = ggplot2::element_blank(),
                   legend.direction = 'horizontal',
                   legend.position = 'top') + ggplot2::scale_y_reverse()
  
  rrrPlot <- ggplot2::ggplot(relative, ggplot2::aes(x = riskStratum,
                                                    y = estimate)) +
    ggplot2::geom_point(size = 3,
                        position = ggplot2::position_dodge(w = .3)) +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = lowerBound, ymax = upperBound),
                           width = 0,
                           position = ggplot2::position_dodge(w = .3)) +
    ggplot2::geom_hline(yintercept = 1, linetype = 'dashed', size = .8) +
    ggplot2::xlab('Risk Stratum') +
    ggplot2::ylab('Hazard Ratio') +
    # ggplot2::coord_cartesian(ylim = ylimRRR) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.title = ggplot2::element_blank(),
                   legend.position = 'none',
                   axis.title.x = ggplot2::element_blank(),
                   axis.text.x = ggplot2::element_blank())
  
  arrPlot <- ggplot2::ggplot(absolute, ggplot2::aes(x = riskStratum,
                                                    y = estimate*100)) +
    ggplot2::geom_point(size = 3,
                        position = ggplot2::position_dodge(w = .3)) +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = lowerBound*100, ymax = upperBound*100),
                           width = 0,
                           position = ggplot2::position_dodge(w = .3)) +
    ggplot2::geom_hline(yintercept = 0, linetype = 'dashed', size = .8) +
    ggplot2::xlab('Risk stratum median risk (%)') +
    ggplot2::ylab('Absolute \n Risk Reduction (%)') +
    # ggplot2::coord_cartesian(ylim = ylimARR) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.direction = 'horizontal',
                   legend.position = 'bottom',
                   legend.title = ggplot2::element_blank())
  
  ggpubr::ggarrange(casesPlot, rrrPlot, arrPlot, nrow = 3, align = "v")
}