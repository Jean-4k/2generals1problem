# 2generals1problem

A GPLv2 simulation of the 2 generals problem.

## How to use

You must have a lisp evaluator on your machine.
For instance, you can install sbcl :
```lisp
apt install sbcl
```

Clone the directory, then go within, and start a sbcl session :
```bash
sbcl --load simulation.lisp
```

To quit the sbcl interpreter, you can type :
```lisp
(quit)
```

Everything is ready, you can enter functions.

## Commands

Here is an example of `tester` function :
```lisp
(tester 10)
```

`10` is the number of random tests to be executed.

You can set the `:verbeux?` keywork to `t` (true) to see the output of the tests.
Note that the number of tests if mandatory.

```lisp
(tester 1 :verbeux? t)
```

If you do not want to measure time spent in `tester` function, you can use the `tester*` function :
```lisp
(tester* 1 :verbeux? t)
```
