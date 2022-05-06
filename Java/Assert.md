assertEqual(a,b，[msg='测试失败时打印的信息'])： 断言a和b是否相等，`相等`则测试用例通过。

assertNotEqual(a,b，[msg='测试失败时打印的信息'])： 断言a和b是否相等，`不相等`则测试用例通过。

assertTrue(x，[msg='测试失败时打印的信息'])： 断言x是否True，`是True`则测试用例通过。

assertFalse(x，[msg='测试失败时打印的信息'])： 断言x是否False，`是False`则测试用例通过。

assertIs(a,b，[msg='测试失败时打印的信息'])： 断言a是否是b，`是`则测试用例通过。

assertNotIs(a,b，[msg='测试失败时打印的信息'])： 断言a是否是b，`不是`则测试用例通过。

assertIsNone(x，[msg='测试失败时打印的信息'])： 断言x是否None，`是None`则测试用例通过。

assertIsNotNone(x，[msg='测试失败时打印的信息'])： 断言x是否None，`不是None`则测试用例通过。

assertIn(a,b，[msg='测试失败时打印的信息'])： 断言a是否在b中，`在b中`则测试用例通过。

assertNotIn(a,b，[msg='测试失败时打印的信息'])： 断言a是否在b中，`不在b中`则测试用例通过。

assertIsInstance(a,b，[msg='测试失败时打印的信息'])： 断言a是b的一个实例，`是`则测试用例通过。

assertNotIsInstance(a,b，[msg='测试失败时打印的信息'])： 断言a不是b的一个实例，`不是`则测试用例通过