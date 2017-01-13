dummy-moxunit-example-for-issue
===============================

Demonstrate that MOxUnit masks an internal octave error in the implementation
of `initTestSuite`.

Usage
-----

- Install [MOxUnit](https://github.com/MOxUnit/MOxUnit)
- Run tests: `octave-cli --eval moxunit_runtests`

Results
-------

```bash
$ octave-cli --eval moxunit_runtests
suite: 0 tests

--------------------------------------------------

OK
ans = 1
```

Comments
--------

The previous results seems to indicate that MOxUnit does not recognize the
existence of a test suite, which is very strange, since all the
[conventions](https://github.com/MOxUnit/MOxUnit#defining-moxunit-tests) were
respected.

A deeper investigation shows that, MOxUnit does find the test suite, but an
error occurs when running `initTestSuite`.
One can hack the `MOxUnit/MOxUnit/initTestSuite.m` file and insert the
following lines of code inside the empty `catch` statement
(for the commit `3cd167f`, it corresponds to lines 81, 82):

```matlab
fprintf('----- Error! -----\n');
disp(lasterr);
fprintf('------------------\n\n');
```

Running the test again results in the following output:

```bash
$ octave-cli --eval moxunit_runtests
----- Error! -----
handles to nested functions are not yet supported
------------------

suite: 0 tests

--------------------------------------------------

OK
ans = 1
```

In summary, the generic `try ... catch ...` block, with and empty rescue
section, masks the octave internal error, and makes debugging a nightmare.
I don't know if there is an specific reason for this block, but maybe just
removing it solves the problem.

