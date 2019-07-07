@echo off
rem Uses Saxon HE 9.9 .NET version
set SAXONPATH=D:\tools\SaxonHE9.9N\bin

%SAXONPATH%\Transform -s:Sample2.xml -xsl:package2svg.xsl -o:Sample2.svg
%SAXONPATH%\Transform -s:Sequences.xml -xsl:package2svg.xsl -o:Sequences.svg
%SAXONPATH%\Transform -s:Sequences.1.xml -xsl:package2svg.xsl -o:Sequences.1.svg