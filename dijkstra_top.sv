`include "constants.sv"
`timescale 1ps/1ps

// Top level module for the HW implementation of Dijkstra's algorithm
module DijkstraTop
#(
	parameter MAX_NODES=`DEFAULT_MAX_NODES,
	parameter INDEX_WIDTH=`DEFAULT_INDEX_WIDTH,
	parameter VALUE_WIDTH=`DEFAULT_VALUE_WIDTH,
	parameter MADDR_WIDTH=`DEFAULT_MADDR_WIDTH,
	parameter MDATA_WIDTH=`DEFAULT_MDATA_WIDTH
)
(
	input wire reset,
	input wire clock,
	input wire enable,

	input wire[INDEX_WIDTH-1:0] source,
	input wire[INDEX_WIDTH-1:0] destination,

	input wire[INDEX_WIDTH-1:0] number_of_nodes,
	input wire[MADDR_WIDTH-1:0] base_address,

	output wire mem_read_enable,
	output wire mem_write_enable,

	input wire mem_write_ready,
	input wire mem_read_ready,

	output wire [MADDR_WIDTH-1:0] mem_addr,
	input wire [MDATA_WIDTH-1:0] mem_read_data,
	output wire [MDATA_WIDTH-1:0] mem_write_data,

	output wire[VALUE_WIDTH-1:0] shortest_distance,

	output reg ready
);

// Reset components at our will
reg controlled_ec_reset;
reg controlled_pq_reset;

// Keep track of paths
reg [INDEX_WIDTH-1:0] prev_vector[MAX_NODES-1:0];

// States for the FSM
typedef enum {RESET_STATE, READY_STATE, V0, V1, V2, V3, V4, V5, WRITE_STATE, FINAL_STATE} State ;
State state;
State next_state;

// Visited nodes
integer number_of_unvisited_nodes;
reg [MAX_NODES-1:0] visited_vector;

wire [VALUE_WIDTH-1:0] dist_vector[MAX_NODES-1:0];
assign shortest_distance = dist_vector[destination];

// Just for for loops
integer i;

// The node we're visiting
reg[INDEX_WIDTH-1:0] current_node;
reg[VALUE_WIDTH-1:0] current_node_value;

// Reduction variable
reg[VALUE_WIDTH-1:0] alt;


reg pq_set_distance;
reg[INDEX_WIDTH-1:0] pq_index;
reg[VALUE_WIDTH-1:0] pq_distance_to_set;
wire[VALUE_WIDTH-1:0] pq_distance_read;
wire[INDEX_WIDTH-1:0] min_distance_node_index;
wire[VALUE_WIDTH-1:0] min_distance_node_value;
wire min_ready;

PriorityQueue #(.MAX_NODES(MAX_NODES), .INDEX_WIDTH(INDEX_WIDTH), .VALUE_WIDTH(VALUE_WIDTH))
	priority_queue (
		controlled_pq_reset,
		clock,
		pq_set_distance,
		pq_index,
		visited_vector,
		pq_distance_to_set,
		pq_distance_read,
		min_distance_node_index,
		min_distance_node_value,
		min_ready,
		dist_vector
	);


reg ec_query;
reg[INDEX_WIDTH-1:0] ec_from_node;
reg[INDEX_WIDTH-1:0] ec_to_node;
wire ec_ready;
wire [VALUE_WIDTH-1:0] ec_edge_value;




endmodule