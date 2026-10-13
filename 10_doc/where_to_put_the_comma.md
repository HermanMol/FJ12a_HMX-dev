# Where to put the comma?

## Introduction
I spend most of my work programming Oracle SQL and PL/SQL. Ofcourse much time is
consumed by maintaining existing code. Here it is essential the code is
readable and many times I start with reformatting the code. Put it in a format
that _I_ like.

This refactoring helps me understanding the code, it's structure. So
the reformatting is not wasted time. On the contrary! But many times I note that 
my preferences differ from most(?) tools or programmers. Especially where it 
comes to the immense important question ;-) :  

__Where to put the comma?__

## Where to put it?
My preference is that in a continued statement the comma should __always__ be at 
the beginning of a line and __never__ at the end of the prior line. 

Why? 

Simple! Just ask yourself the question: To what part of the code does the 
comma _belong_ to? 

>It is a character that indicates the next part is __a continuation__ of the 
>prior part. If there would be no next part, then there would also be no 
>comma! 

## Advantages of the comma at the beginning
1. You immediately see that the line is part of the statement started on a prior
line.
1. It eases the method of _"vertical code reading"_; your eyes need less 
movements to navigate thru the code, because you don't have to read whole lines, scroll 
horizontally or get to the end of the line (of these ever increasing 
monitors) to find whether the statement is continued. Or not.
1. Compare to a line comment: that also _starts_ with the comment indicator 
( --, #, \*, etc.)
1. Compare to a bullet list. Having the bullet at the end would be weird!
1. Comment on a line after a statement is not separated by a comma from the
part being commented.
1. If you must add a parameter or value to a list, you only have to insert 
a new line, start with the comma and code the parameter or value. If the 
comma is at the end of the lines you have to go to the end of the line, code 
the comma, insert a new line and only then code the parameter or value.
1. The _"comma-at-the-end"_ style also has the disadvantage that when you 
compare two versions of a piece of code, you also get the lines where only the 
comma was added; with the comma at the begin, you get only the inserted lines!
1. If you must (temporarily) comment a line, you do not need to bother about 
whether you have to remove the "continuation comma" at the end of the prior 
line. And when to un-comment the line again... but that comma back.
1. Often I generate code from some SQL statement. It's much easier to add a comma 
at the begin of each new line, then figuring out if the last line has been 
reached. Example:
>`select decode(rownum,1,' ',',') || column_name as stmt_part from user_tab_columns where table_name = upper(:table_name)`

## Think of this
Code is not natural language:
- Statements ending with a semicolon and not a period
- The indendation
- Color coding
- Camel case
- Aligning statement parts
- Brackets, braces and curly braces
- Abbreviations
- ... 

