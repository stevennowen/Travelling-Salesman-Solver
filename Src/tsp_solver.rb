    # tsp_solver.rb

    class TSP_DP
    attr_reader :adj_matrix, :n, :start_node
    attr_reader :memo, :path_memo 

    def initialize(matrix)
        @adj_matrix = matrix
        @n = matrix.length
        @start_node = 0 
        @memo = {} 
        @path_memo = {} 
    end


    def dp_calculate(u, mask)

        return adj_matrix[u][start_node] if mask == 0

        state = [u, mask]
        return memo[state] if memo.key?(state)

        min_cost_for_state = Float::INFINITY
        best_next_city_for_path = -1 

        (0...n).each do |v| 
        if (mask & (1 << v)) != 0
            
            cost_via_v = adj_matrix[u][v] + dp_calculate(v, mask ^ (1 << v))

            if cost_via_v < min_cost_for_state
            min_cost_for_state = cost_via_v
            best_next_city_for_path = v
            end
        end
        end

        memo[state] = min_cost_for_state
        path_memo[state] = best_next_city_for_path
        min_cost_for_state
    end

    def solve
        if n == 0
        return { cost: 0, path: [] }
        end
        if n == 1
        return { cost: 0, path: [start_node] }
        end

        min_overall_tour_cost = Float::INFINITY
        first_hop_from_start = -1 

        (0...n).each do |k| 
        next if k == start_node

        mask_for_k_leg = ((1 << n) - 1) ^ (1 << start_node) ^ (1 << k)
        
        current_path_total_cost = adj_matrix[start_node][k] + dp_calculate(k, mask_for_k_leg)

        if current_path_total_cost < min_overall_tour_cost
            min_overall_tour_cost = current_path_total_cost
            first_hop_from_start = k
        end
        end

        if min_overall_tour_cost == Float::INFINITY
        return { cost: Float::INFINITY, path: [] } 
        end


        tour = [start_node]

        if first_hop_from_start == -1 && n > 1
            
            return { cost: min_overall_tour_cost, path: [start_node, start_node] } if min_overall_tour_cost == (adj_matrix[start_node][start_node] || 0)

            return { cost: min_overall_tour_cost, path: [start_node] } 
        end

        current_city_in_path = first_hop_from_start
        tour << current_city_in_path

        mask_for_reconstruction = ((1 << n) - 1) ^ (1 << start_node) ^ (1 << first_hop_from_start)

        while mask_for_reconstruction != 0
        
        next_node_in_tour = path_memo[[current_city_in_path, mask_for_reconstruction]]
        
        break if next_node_in_tour.nil? || next_node_in_tour == -1 

        tour << next_node_in_tour
        mask_for_reconstruction ^= (1 << next_node_in_tour) 
        current_city_in_path = next_node_in_tour
        end

        tour << start_node 

        { cost: min_overall_tour_cost, path: tour }
    end

    def self.get_input_matrix
        print "Masukkan jumlah kota: "
        num_cities = gets.to_i

        if num_cities <= 0
        puts "Jumlah kota harus positif."
        return nil
        end

        puts "Masukkan adjacency matrix (setiap baris pada baris baru, nilai dipisahkan spasi):"
        puts "(Gunakan angka yang besar jika tidak ada jalur langsung, misal 99999)"
        matrix = []
        num_cities.times do |i|
        print "Baris #{i} (untuk kota #{i}): "
        begin
            row_values = gets.chomp.split.map do |val|
            v = Integer(val)
            
            raise ArgumentError, "Biaya tidak boleh negatif." if v < 0
            v
            end

            if row_values.length != num_cities
            puts "Error: Baris #{i} memiliki #{row_values.length} elemen, diharapkan #{num_cities}."
            return nil
            end
            matrix << row_values
        rescue ArgumentError => e 
            puts "Input tidak valid: #{e.message}. Harap masukkan integer yang valid."
            return nil
        end
        end
        matrix
    end
    end

    if __FILE__ == $PROGRAM_NAME
    puts "Penyelesaian TSP menggunakan Dynamic Programming"
    puts "--------------------------------------------------------------------"
    adj_matrix = TSP_DP.get_input_matrix

    if adj_matrix
        puts "\nAdjacency Matrix yang Dimasukkan:"
        adj_matrix.each { |row| puts row.map { |val| val.to_s.rjust(5) }.join }
        
        tsp_solver = TSP_DP.new(adj_matrix)
        result = tsp_solver.solve

        puts "\n--- Hasil ---"
        if result[:cost] == Float::INFINITY
        puts "Tidak ditemukan tur TSP."
        else
        puts "Biaya TSP optimal: #{result[:cost]}"
        puts "Jalur TSP optimal: #{result[:path].join(' -> ')}" 
        end
    else
        puts "Gagal mendapatkan matriks input."
    end
    end