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


void tree_node_set_text_bounds ( struct tree_node *node, struct tree_node *first,
                                 struct tree_node *last )
{
    if ( first && ( !node->text_line_from ||
                    ( first->text_line_from &&
                      node->text_line_from > first->text_line_from ) ||
                    ( node->text_line_from == first->text_line_from &&
                      node->text_column_from > first->text_column_from ) ) ) {

        node->text_line_from = first->text_line_from;
        node->text_column_from = first->text_column_from;
        node->prev_token = first->prev_token;
    }

    if ( last && ( node->text_line_to < last->text_line_to ||
                   ( node->text_line_to == last->text_line_to &&
                     node->text_column_to < last->text_column_to ) ) ) {

        node->text_line_to = last->text_line_to;
        node->text_column_to = last->text_column_to;
        node->next_token = last->next_token;
    }
}


/* WARNING: may have to maintain {prev,next}_tokens manually (if non-member
            tokens are at the begining/end */

void tree_node_push_front ( struct tree_node *node, struct tree_node *child ) {

    child->parent = node;
    child->next_sibling = node->first_child;
    child->prev_sibling = NULL;

    if ( node->child_count++ ) {

        node->first_child->prev_sibling = child;
        tree_node_set_text_bounds( node, child, NULL );

    } else {

        node->last_child = child;
        tree_node_set_text_bounds( node, child, child );
    }

    node->first_child = child;
}


void tree_node_push_back ( struct tree_node *node, struct tree_node *child ) {

    child->parent = node;
    child->next_sibling = NULL;
    child->prev_sibling = node->last_child;

    if ( node->child_count++ ) {

        node->last_child->next_sibling = child;
        tree_node_set_text_bounds( node, NULL, child );

    } else {

        node->first_child = child;
        tree_node_set_text_bounds( node, child, child );
    }

    node->last_child = child;
}


struct tree_node* tree_node_get_child ( struct tree_node *node, int pos ) {

    if ( node->child_count <= pos )
        return NULL;

    for ( node = node->first_child; pos; pos-- ) {

        node = node->next_sibling;
    }

    if ( node->node_type == NODE_NONE )
        return NULL;

    return node;
}


void tree_node_set_child ( struct tree_node *node, int pos,
                           struct tree_node *child )
{
    if ( node->child_count <= pos ) {

        for ( ; node->child_count < pos; pos-- ) {

            tree_node_push_back( node, new_tree_node() );
        }

        tree_node_push_back( node, child );

    } else {

        node = tree_node_get_child( node, pos );

        child->parent = node->parent;
        child->prev_sibling = node->prev_sibling;
        child->next_sibling = node->next_sibling;

        delete_tree( node );

        if ( child->prev_sibling ) {
            child->prev_sibling->next_sibling = child;
        } else {
            child->parent->first_child = child;
        }

        if ( child->next_sibling ) {
            child->next_sibling->prev_sibling = child;
        } else {
            child->parent->last_child = child;
        }
    }
}

