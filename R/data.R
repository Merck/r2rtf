#    Copyright (c) 2020 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.
#
#    This file is part of the r2rtf program.
#
#    r2rtf is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' An Adverse Event Dataset
#'
#' A dataset containing the adverse event information of a clinical trial following
#' CDISC ADaM standard.
#'
#' Definition of each variable can be found in
#' \url{https://bitbucket.cdisc.org/projects/CED/repos/sdtm-adam-pilot-project/browse}
#'
#' @format A data frame with 1191 rows and 55 variables.
#'
#' @source \url{https://bitbucket.cdisc.org/projects/CED/repos/sdtm-adam-pilot-project/browse}
#'
"r2rtf_adae"

#' A Subject Level Demographic Dataset
#'
#' A dataset containing the demographic information of a clinical trial following
#' CDISC ADaM standard.
#'
#' Definition of each variable can be found in
#' \url{https://bitbucket.cdisc.org/projects/CED/repos/sdtm-adam-pilot-project/browse}
#'
#' @format A data frame with 254 rows and 51 variables.
#'
#' @source \url{https://bitbucket.cdisc.org/projects/CED/repos/sdtm-adam-pilot-project/browse}
"r2rtf_adsl"

#' An Efficacy Clinical Trial Data to Evaluate a Drug to Reduce Lower Back Pain
#'
#' A dataset prepared by the Drug Information Association scientific working group
#' to investigate a drug to reduce lower back pain.
#'
#' Definition of each variable can be found in \url{https://missingdata.lshtm.ac.uk/dia-working-group/}
#'
#' @format A data frame with 831 rows and 6 variables.
#'
#' @source \url{https://missingdata.lshtm.ac.uk/dia-working-group/}
"r2rtf_HAMD17"

#' Within Group Results from an ANCOVA Model
#'
#' A dataset containing within group results from an ANCOVA model.
#'
#' @format A data frame with 2 rows and 8 variables.
"r2rtf_tbl1"

#' Between Group Results from an ANCOVA Model
#'
#' A dataset containing between group results from an ANCOVA model.
#'
#' @format A data frame with 1 row and 3 variables.
"r2rtf_tbl2"

#' Root Mean Square Error from an ANCOVA model
#'
#' A dataset containing root mean square error from an ANCOVA model.
#'
#' @format A data frame with 1 row and 1 variable.
"r2rtf_tbl3"

#' Dictionary of Unicode and Latex Code
#'
#' A dataset containing the mapping between unicode and latex code.
#'
#' @format A data frame with 681 rows and 3 variables.
#' \describe{
#'    \item{unicode}{unicode, UTF-8 code}
#'    \item{latex}{latex, latex code}
#'    \item{int}{int, Converted integer of the UTF-8 code}
#' }
#'
#' @source \url{http://milde.users.sourceforge.net/LUCR/Math/data/unimathsymbols.txt}
"unicode_latex"
