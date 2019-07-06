@echo off
rem Uses Saxon HE 9.9 .NET version
set SAXONPATH=D:\tools\SaxonHE9.9N\bin

%SAXONPATH%\Transform -s:Beginning.xml -xsl:package2svg.xsl -o:Beginning.svg

rem %SAXONPATH%\Transform -s:Sample2.xml -xsl:package2svg.xsl -o:Sample2.svg
%SAXONPATH%\Transform -s:01.xml -xsl:01.xsl -o:01.svg
%SAXONPATH%\Transform -s:02.xml -xsl:02.xsl -o:02.svg
%SAXONPATH%\Transform -s:03.xml -xsl:03.xsl -o:03.svg

