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

#' Unicode characters and corresponding LaTeX math mode commands
#'
#' A dataset containing the unicode, character and latex command.
#'
#'
#' @format A data frame with 2757 rows and 3 variables:
#' \describe{
#'   \item{unicode}{Unicode character number}
#'   \item{chr}{literal character (UTF-8 encoded)}
#'   \item{latex}{Latex command}
#' }
#' @source \url{http://milde.users.sourceforge.net/LUCR/Math/data/unimathsymbols.txt}
"unicode_latex"
