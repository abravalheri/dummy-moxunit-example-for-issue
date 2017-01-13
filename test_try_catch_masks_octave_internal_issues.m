function test_suite = test_try_catch_masks_octave_internal_issues
  initTestSuite;
end

function test_function_handle_not_called
  function x = callback
    x = 1;
  end

  func = @callback;
  assert(func() == 1);
end
