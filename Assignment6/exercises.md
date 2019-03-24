# Assignment 6

## Problem 1
### a
Two sets are said to be union compatible if they have the same number of attributes (same degree) and each
pair of corresponding attributes are type compatible, i.e. have the same domain.

### b
#### a
Pi (No_of_copies) (  ( Sigma (title = "The lost tribe") (Book) * Book_copies) * Sigma (Branch_name = "Sharpstown")(Library_branch)))

#### b

Pi (Branch_name, No_of_copies) (( Sigma (title = "The lost tribe") (Book) * Book_copies) * Library_branch)

## Problem 2

### a

SELECT snumber , AVG( grade )FROM grades GROUP BY snumber HAVING AVG( grade )>5 . 5 ;

group by and average <- snumber BIGF AVERAGE grade  (Student) snumber and avg grade
passed <- sigma (average > 5.5) (group by and average)

### b

SELECT SUM( volume )FROM f e r t i l i z e ra p p l i c a t i o n sLEFT JOIN  c r o pf i e l dON f e r t i l i z e ra p p l i c a t i o n s . c r o pf i e l di d = c r o pf i e l d . idGROUP BY fieldnumberHAVING fieldnumber = 3;

join <- fertilizer_applications OUTERLEFTJOIN (fertilizer_applications.crop_field_id = crop_field.id) crop_field;
sum <- field_number BIGF sum join
result <-  Pi (sum) (Sigma (field_number = 3) sum)
