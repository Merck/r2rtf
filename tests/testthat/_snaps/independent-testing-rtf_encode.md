# Test if content is converted to RTF correctly when tbl class is list

    $start
    [1] "{\\rtf1\\ansi\n\\deff0\\deflang1033\n{\\fonttbl{\\f0\\froman\\fcharset161\\fprq2 Times New Roman;}\n{\\f1\\froman\\fcharset161\\fprq2 Times New Roman Greek;}\n{\\f2\\fswiss\\fcharset161\\fprq2 Arial Greek;}\n{\\f3\\fswiss\\fcharset161\\fprq2 Arial;}\n{\\f4\\fswiss\\fcharset161\\fprq2 Helvetica;}\n{\\f5\\fswiss\\fcharset161\\fprq2 Calibri;}\n{\\f6\\froman\\fcharset161\\fprq2 Georgia;}\n{\\f7\\ffroman\\fcharset161\\fprq2 Cambria;}\n{\\f8\\fmodern\\fcharset161\\fprq2 Courier New;}\n{\\f9\\ftech\\fcharset161\\fprq2 Symbol;}\n}\n\n"
    
    $body
    [1] "\\paperw12240\\paperh15840\n\n\\margl1800\\margr1440\\margt2520\\margb1800\\headery2520\\footery1449\n\n\n\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 X1}\\cell\n\\intbl\\row\\pard\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 1}\\cell\n\\intbl\\row\\pard\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 X1}\\cell\n\\intbl\\row\\pard\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 1}\\cell\n\\intbl\\row\\pard\n\n\n{\\pard\\par}"
    
    $end
    [1] "}"
    

# Test if content is converted to RTF correctly when tbl class is data.frame

    $start
    [1] "{\\rtf1\\ansi\n\\deff0\\deflang1033\n{\\fonttbl{\\f0\\froman\\fcharset161\\fprq2 Times New Roman;}\n{\\f1\\froman\\fcharset161\\fprq2 Times New Roman Greek;}\n{\\f2\\fswiss\\fcharset161\\fprq2 Arial Greek;}\n{\\f3\\fswiss\\fcharset161\\fprq2 Arial;}\n{\\f4\\fswiss\\fcharset161\\fprq2 Helvetica;}\n{\\f5\\fswiss\\fcharset161\\fprq2 Calibri;}\n{\\f6\\froman\\fcharset161\\fprq2 Georgia;}\n{\\f7\\ffroman\\fcharset161\\fprq2 Cambria;}\n{\\f8\\fmodern\\fcharset161\\fprq2 Courier New;}\n{\\f9\\ftech\\fcharset161\\fprq2 Symbol;}\n}\n\n"
    
    $body
    [1] "\\paperw12240\\paperh15840\n\n\\margl1800\\margr1440\\margt2520\\margb1800\\headery2520\\footery1449\n\n\n\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdb\\brdrw15\\cellx1800\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdb\\brdrw15\\cellx3600\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdb\\brdrw15\\cellx5400\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdb\\brdrw15\\cellx7200\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdb\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 Sepal.Length}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 Sepal.Width}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 Petal.Length}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 Petal.Width}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 Species}\\cell\n\\intbl\\row\\pard\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx1800\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx3600\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx5400\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx7200\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 5.1}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 3.5}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 1.4}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 0.2}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 setosa}\\cell\n\\intbl\\row\\pard\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrb\\brdrdb\\brdrw15\\cellx1800\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrb\\brdrdb\\brdrw15\\cellx3600\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrb\\brdrdb\\brdrw15\\cellx5400\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrb\\brdrdb\\brdrw15\\cellx7200\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrdb\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 4.9}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 3}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 1.4}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 0.2}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 setosa}\\cell\n\\intbl\\row\\pard\n\n\n{\\pard\\par}\n"
    
    $end
    [1] "}"
    

