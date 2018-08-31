# Zig SingularLinkList

A Singular link list in zig. No claim this is good or
even correct yet, but it works for a few tests.

## Test on my desktop debug
```bash
$ zig test --test-filter Sll --release-fast singular_link_list.zig 
Test 1/7 Sll.empty...OK
Test 2/7 Sll.empty.iterator...OK
Test 3/7 Sll.one.element...Sll.one.element: iter pNode.data=1
OK
Test 4/7 Sll.two.elements...Sll.two.element: iter pNode.data=1
Sll.two.element: iter pNode.data=2
OK
Test 5/7 Sll.three.elements...Sll.two.element: iter pNode.data=1
Sll.two.element: iter pNode.data=2
Sll.two.element: iter pNode.data=3
OK
Test 6/7 SllBm1000...
name repetitions:10       iterations        time    time/operation
SllBM1000                     537824     0.603 s    1121.371 ns/op
SllBM1000                     537824     0.604 s    1122.879 ns/op
SllBM1000                     537824     0.604 s    1123.094 ns/op
SllBM1000                     537824     0.604 s    1122.251 ns/op
SllBM1000                     537824     0.605 s    1124.771 ns/op
SllBM1000                     537824     0.605 s    1124.167 ns/op
SllBM1000                     537824     0.604 s    1123.368 ns/op
SllBM1000                     537824     0.605 s    1125.535 ns/op
SllBM1000                     537824     0.604 s    1123.548 ns/op
SllBM1000                     537824     0.604 s    1123.840 ns/op
SllBM1000                     537824     0.604 s    1123.482 ns/op mean
SllBM1000                     537824     0.604 s    1123.458 ns/op median
SllBM1000                     537824     0.001 s       1.201 ns/op stddev
OK
Test 7/7 SllBm1000.iter...
name repetitions:10       iterations        time    time/operation
SllBM1000.iter                537824     0.603 s    1121.047 ns/op
SllBM1000.iter                537824     0.603 s    1120.419 ns/op
SllBM1000.iter                537824     0.603 s    1120.623 ns/op
SllBM1000.iter                537824     0.605 s    1124.346 ns/op
SllBM1000.iter                537824     0.603 s    1121.888 ns/op
SllBM1000.iter                537824     0.603 s    1121.804 ns/op
SllBM1000.iter                537824     0.603 s    1121.306 ns/op
SllBM1000.iter                537824     0.602 s    1119.971 ns/op
SllBM1000.iter                537824     0.603 s    1121.250 ns/op
SllBM1000.iter                537824     0.602 s    1119.569 ns/op
SllBM1000.iter                537824     0.603 s    1121.222 ns/op mean
SllBM1000.iter                537824     0.603 s    1121.148 ns/op median
SllBM1000.iter                537824     0.001 s       1.328 ns/op stddev
OK
All tests passed.
```

## Clean
Remove `zig-cache/` directory
```bash
$ rm -rf ./zig-cache/
```
