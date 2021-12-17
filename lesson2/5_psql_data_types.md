# PostgreSQL Data Types Practice Problems

## 1

While `text` and `varchar` data types both deal with character data, they vary in their length limitations. `text` will allow an unlimited amount of text, while `varchar` sets a limit on the number of characters. That number is passed to `varchar` as argument like so: `varchar(n)`, for example `varchar(50)`. If data that is longer than the specified number of characters is added to a column with `varchar` data types, PostgreSQL will raise an error.

## 2

`integer`, `decimal`, and `real` data types are all numeric data types. `integer` data is always whole number data, ranging from -2147483648 to 2147483648. `real` data refers to floating point number data, and puts no restriction on the amount of precision, aka numbers after the decimal point, that can be used, for example `3.1459....`. `decimal` allows us to set both the total amount of precision as well as the number of digits that come after the decimal point when dealing with floating point numbers. This is generally preferred to avoid floating point rounding errors. When assigning a `decimal` data type, we must also provide the amount of precision (total number of digits), and the amount of digits permitted after the decimal point. For example `decimal(5, 2)` would allow numbers in the range -999.99 to 999.99.

## 3

The largest value that can be stored in an integer column is 2147483647.

## 4

The `timestamp` and `date` data types both deal with dates and times. `timestamp` includes _both_ a date and a time (such as `2021-12-17 03:15:34`), while `date` only includes the date (such as `2021-12-17`).

## 5

A time zone cannot be stored in a column of type `timestamp`, but we can use the `timestamp with time zone` data type to store these kinds of values.
