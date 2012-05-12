#include <stdlib.h>
#include "tree_node.h"


struct tree_node* new_tree_node ( void ) {

    struct tree_node *node = calloc( sizeof( struct tree_node ), 1 );

    if ( !node ) {
        /* you are in trouble (TODO) */ ;
    }

    return node;
}


void delete_tree_node ( struct tree_node* node ) {

    if ( !node )
        return;

    if ( node->next_sibling ) {

        node->next_sibling->prev_sibling = node->prev_sibling;

    } else if ( node->parent ) {

        node->parent->last_child = node->prev_sibling;
    }

    if ( node->prev_sibling ) {

        node->prev_sibling->next_sibling = node->next_sibling;

    } else if ( node->parent ) {

        node->parent->first_child = node->next_sibling;
    }

    free( node );
}


void delete_tree ( struct tree_node* node ) {

    if ( !node )
        return;

    while ( node->first_child ) {

        node->last_child = node->first_child->next_sibling;

        delete_tree( node->first_child );

        node->first_child = node->last_child;
    }

    delete_tree_node( node );
}

