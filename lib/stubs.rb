def initialize_stubs
  @stubs = {
    raw: {
      cell:  File.read('stubs/cell.html'),
      grid:  File.read('stubs/grid.html'),
      style: File.read('stubs/style.css')
    },
    cells: ""
  }
end
