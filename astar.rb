
class AStar
  def neighbors( node )
    []
  end

  def edge_cost( from, to )
    1
  end

  def heuristic( from, to )
    0
  end

  def is_goal?( node )
    goal === node
  end

  def start_cost
    0
  end

  def visited( node )
    # noop, override as a hook
  end

  def known_cost( node )
    @known_cost[ node ]
  end

  def estimated_cost( current )
    @known_cost[current] + heuristic( current, @goal )
  end

  attr_reader :start, :goal
  def initialize( start, goal )
    @start, @goal = start, goal
    @open = {start => true}
    @parent = {}
    @closed = {}
    @known_cost = {start => start_cost}
  end

  def close( node )
    @closed[node] = true
    @open.delete(node)
  end

  def check_neighbors( node )
    neighbors(node).each do |n|
      next if @closed[n]
      direct_cost = known_cost(node) + edge_cost( node , n )
      if ! known_cost(n) or known_cost(n) > direct_cost
        @known_cost[n] = direct_cost
        @parent[n] = node
        @open[n] = true
      end
    end
  end

  def find_next
    @open.keys.sort_by{ |n| estimated_cost( n ) }.first
  end

  def path_to(node)
    path = []
    while @parent[node] do
      path = [node] + path
      node = @parent[node]
    end
  end

  def search(&blk)
    loop do
      node = find_next

      visited(node)

      return nil if node.nil?

      if is_goal?(node)
        path = path_to(node)
        if blk
          blk.call( path )
        else
          return path
        end
      end

      close( node )
      check_neighbors( node )
    end
  end

end
