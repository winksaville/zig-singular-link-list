# Zig SingularLinkList

A Singular link list in zig. No claim this is good or
even correct yet, but it works for a few tests.


## Test on my desktop debug
```bash
$ time zig test --test-filter Sll --release-fast singular_link_list.zig
Test 1/5 Sll.empty...OK
Test 2/5 Sll.one.element...OK
Test 3/5 Sll.two.elements...OK
Test 4/5 Sll.three.elements...OK
Test 5/5 SllBm1000...
name repetitions:10       iterations        time    time/operation
SllBM1000                     537824     0.607 s    1128.266 ns/op
SllBM1000                     537824     0.606 s    1126.934 ns/op
SllBM1000                     537824     0.606 s    1127.586 ns/op
SllBM1000                     537824     0.607 s    1128.319 ns/op
SllBM1000                     537824     0.607 s    1128.055 ns/op
SllBM1000                     537824     0.608 s    1130.747 ns/op
SllBM1000                     537824     0.606 s    1127.630 ns/op
SllBM1000                     537824     0.606 s    1126.845 ns/op
SllBM1000                     537824     0.607 s    1128.727 ns/op
SllBM1000                     537824     0.609 s    1131.609 ns/op
SllBM1000                     537824     0.607 s    1128.472 ns/op mean
SllBM1000                     537824     0.607 s    1128.160 ns/op median
SllBM1000                     537824     0.001 s       1.557 ns/op stddev
OK
All tests passed.

real	0m17.325s
user	0m17.228s
sys	0m0.072s
```

## Clean
Remove `zig-cache/` directory
```bash
$ rm -rf ./zig-cache/
```
