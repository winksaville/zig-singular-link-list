pub const Link = struct {
    ptr: ?*Link,
};

pub const SingularLinkList = struct {
    const Self = this;

    // tail.ptr.?.ptr is head
    tail: Link,

    fn init() Self {
        return Self {
            .tail = Link { .ptr = null, },
        };
    }

    // Assumes the list is NOT mutated while being traversed
    // for maximum performance
    const NonMutatableIterator = struct {
        const Self = this;

        pSll: *SingularLinkList,
        pCur: ?*Link,
        pHead: ?*Link,
        doneFlag: bool,

        fn init(pSelf: *NonMutatableIterator, pSll: *SingularLinkList) ?*Link {
            pSelf.pSll = pSll;

            if (pSll.tail.ptr == null) {
                pSelf.pHead = null;
                pSelf.pCur = null;
                pSelf.doneFlag = true;
            } else {
                pSelf.pHead = pSll.tail.ptr.?.ptr orelse unreachable;
                pSelf.pCur = pSelf.pHead;
                pSelf.doneFlag = false;
            }

            return pSelf.pCur;
        }

        fn done(pSelf: *NonMutatableIterator) bool {
            return pSelf.doneFlag;
        }

        fn next(pSelf: *NonMutatableIterator) ?*Link {
            var pNext = pSelf.pCur.?.ptr.?;
            if (pNext == pSelf.pHead) {
                // If back to head we're done
                pSelf.doneFlag = true;
            }
            pSelf.pCur = pNext;
            return pNext;
        }
    };

    fn next(pSelf: *Self, pPrev: ?*Link) ?*Link {
        if (pSelf.tail.ptr == null) return null; // empty list
        if (pPrev == null) return pSelf.tail.ptr.?.ptr; // asking for head
        if (pPrev.?.ptr == pSelf.tail.ptr.?.ptr) return null; // reached head return null
        return pPrev.?.ptr;
    }

    fn linkTo(comptime T: type, comptime link_field_name: []const u8, pLink: *Link) *T {
        return @fieldParentPtr(T, link_field_name, pLink);
    }

    fn append(pSelf: *Self, pNext: *Link) void {
        if (pSelf.tail.ptr == null) {
            pSelf.tail.ptr = pNext;
            pNext.ptr = pNext;
        } else {
            pNext.ptr = pSelf.tail.ptr.?.ptr;
            pSelf.tail.ptr.?.ptr = pNext;
            pSelf.tail.ptr = pNext;
        }
    }
};

// Tests

const std = @import("std");
const assert = std.debug.assert;
const assertError = std.debug.assertError;
const warn = std.debug.warn;
const mem = std.mem;
const Allocator = mem.Allocator;

const Sll = SingularLinkList;

const Node = struct {
    const Self = this;

    link: Link,
    data: usize,

    fn initPtr(pSelf: *Self, data: usize) void {
        pSelf.link.ptr = null;
        pSelf.data = data;
    }

    fn init(data: usize) Self {
        return Self {
            .link = Link { .ptr = null },
            .data = data,
        };
    }

    fn linkToNode(pLink: *Link) *Self {
        return Sll.linkTo(Self, "link", pLink);
    }
};

test "Sll.empty" {
    var sll = Sll.init();
    assert(sll.next(null) == null);
    var node: Link = undefined;
    assert(sll.next(&node) == null);

    var pNode: ?*Link = null;
    while (sll.next(pNode)) |pLink| {
        assertError("Expecting the link list to be empty", error.ExpectingEmpty);
    }

    // Test we can loop over an empty SSL
    var p: ?*Link = null;
    var idx: usize = 0;
    while (sll.next(p)) |pLink| {
        assertError("Expecting the link list to be empty", error.ExpectingEmpty);
        idx += 1;
    }
    assert(idx == 0);
}

test "Sll.empty.iterator" {
    var sll = Sll.init();
    assert(sll.next(null) == null);
    var node: Link = undefined;
    assert(sll.next(&node) == null);

    // Test we can loop over an empty SSL
    var iter: Sll.NonMutatableIterator = undefined;
    //var pCur = Sll.NonMutatableIterator.init(&iter, &sll);
    var pCur = iter.init(&sll);
    while (!iter.done()) : (pCur = iter.next()) {
        assertError("Expecting the link list to be empty", error.ExpectingEmpty);
    }
}

test "Sll.one.element" {
    // Initialize
    var sll = Sll.init();
    assert(sll.next(null) == null);

    // Add one element
    var node1 = Node.init(1);
    sll.append(&node1.link);
    
    // Test loop
    var p: ?*Link = null;
    var idx: usize = 0;
    while (sll.next(p)) |pLink| {
        var pNode = Node.linkToNode(pLink);
        assert(pNode.data == idx + 1);
        p = pLink;
        idx += 1;
    }
    assert(idx == 1);

    // Test iterator over a one element list
    var iter: Sll.NonMutatableIterator = undefined;
    var pCur: ?*Link = iter.init(&sll);
    idx = 0;
    while (!iter.done()) : (pCur = iter.next()) {
        var pNode = Node.linkToNode(pCur orelse unreachable);
        warn("Sll.one.element: iter pNode.data={}\n", pNode.data);
        assert(pNode.data == idx + 1);
        idx += 1;
    }
    assert(idx == 1);
}

test "Sll.two.elements" {
    // Initialize
    var sll = Sll.init();
    assert(sll.next(null) == null);
    
    // Add two elements
    var node1 = Node.init(1);
    var node2 = Node.init(2);
    sll.append(&node1.link);
    sll.append(&node2.link);
    
    // Test loop
    var p: ?*Link = null;
    var idx: usize = 0;
    while (sll.next(p)) |pLink| {
        var pNode = Node.linkToNode(pLink);
        assert(pNode.data == idx + 1);
        p = pLink;
        idx += 1;
    }
    assert(idx == 2);

    // Test iterator over a two element list
    var iter: Sll.NonMutatableIterator = undefined;
    var pCur = iter.init(&sll);
    idx = 0;
    while (!iter.done()) : (pCur = iter.next()) {
        var pNode = Node.linkToNode(pCur orelse unreachable);
        warn("Sll.two.element: iter pNode.data={}\n", pNode.data);
        assert(pNode.data == idx + 1);
        idx += 1;
    }
    assert(idx == 2);
}

test "Sll.three.elements" {
    // Initialize
    var sll = Sll.init();
    assert(sll.next(null) == null);
    
    // Add two elements
    var node1 = Node.init(1);
    var node2 = Node.init(2);
    var node3 = Node.init(3);
    sll.append(&node1.link);
    sll.append(&node2.link);
    sll.append(&node3.link);
    
    // Test loop
    var p: ?*Link = null;
    var idx: usize = 0;
    while (sll.next(p)) |pLink| {
        var pNode = Node.linkToNode(pLink);
        assert(pNode.data == idx + 1);
        p = pLink;
        idx += 1;
    }
    assert(idx == 3);

    // Test iterator over a three element list
    var iter: Sll.NonMutatableIterator = undefined;
    var pCur = iter.init(&sll);
    idx = 0;
    while (!iter.done()) : (pCur = iter.next()) {
        var pNode = Node.linkToNode(pCur orelse unreachable);
        warn("Sll.two.element: iter pNode.data={}\n", pNode.data);
        assert(pNode.data == idx + 1);
        idx += 1;
    }
    assert(idx == 3);
}

const Benchmark = @import("../zig-benchmark/benchmark.zig").Benchmark;

fn no_opt() void {
    asm volatile ("": : :"memory");
}

test "SllBm1000" {
    const SllBm1000 = struct {
        const Self = this;

        pAllocator: *Allocator,
        sll: Sll,
        list: []Node,

        fn init(pAllocator: *Allocator) !Self {
            var bm: Self = undefined;

            bm.pAllocator = pAllocator;
            bm.sll = Sll.init();
            bm.list = try pAllocator.alloc(Node, 1000);
            for (bm.list) |_, i| {
                var node = &bm.list[i];
                node.initPtr(i + 1);
                bm.sll.append(&node.link);
            }

            var p: ?*Link = null;
            var idx: usize = 0;
            while (bm.sll.next(p)) |pLink| {
                var pNode = Node.linkToNode(pLink);
                assert(pNode.data == idx + 1);
                p = pLink;
                idx += 1;
            }
            return bm;
        }

        fn deinit(pSelf: *Self) void {
            pSelf.pAllocator.free(pSelf.list);
        }

        fn benchmark(pSelf: *Self) void {
            var p: ?*Link = null;
            var idx: usize = 0;
            while (pSelf.sll.next(p)) |pLink| {
                //no_opt();
                var pNode = Node.linkToNode(pLink);
                assert(pNode.data == idx + 1);
                p = pLink;
                idx += 1;
            }
        }
    };

    var pAllocator = std.debug.global_allocator;
    var bm = Benchmark.init("SllBM1000", pAllocator);
    bm.repetitions = 10;

    var sllBm1000 = try SllBm1000.init(pAllocator);
    defer sllBm1000.deinit();

    warn("\n");
    try bm.run(&sllBm1000);
}

test "SllBm1000.iter" {
    const SllBm1000 = struct {
        const Self = this;

        pAllocator: *Allocator,
        sll: Sll,
        list: []Node,

        fn init(pAllocator: *Allocator) !Self {
            var bm: Self = undefined;

            bm.pAllocator = pAllocator;
            bm.sll = Sll.init();
            bm.list = try pAllocator.alloc(Node, 1000);
            for (bm.list) |_, i| {
                var node = &bm.list[i];
                node.initPtr(i + 1);
                bm.sll.append(&node.link);
            }

            var p: ?*Link = null;
            var idx: usize = 0;
            while (bm.sll.next(p)) |pLink| {
                var pNode = Node.linkToNode(pLink);
                assert(pNode.data == idx + 1);
                p = pLink;
                idx += 1;
            }
            return bm;
        }

        fn deinit(pSelf: *Self) void {
            pSelf.pAllocator.free(pSelf.list);
        }

        fn benchmark(pSelf: *Self) void {
            var iter: Sll.NonMutatableIterator = undefined;
            var pCur = iter.init(&pSelf.sll);
            var idx: usize = 0;
            while (!iter.done()) : (pCur = iter.next()) {
                var pNode = Node.linkToNode(pCur orelse unreachable);
                assert(pNode.data == idx + 1);
                idx += 1;
            }
        }
    };

    var pAllocator = std.debug.global_allocator;
    var bm = Benchmark.init("SllBM1000.iter", pAllocator);
    bm.repetitions = 10;

    var sllBm1000 = try SllBm1000.init(pAllocator);
    defer sllBm1000.deinit();

    warn("\n");
    try bm.run(&sllBm1000);
}
