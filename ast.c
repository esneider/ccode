#include <stdlib.h>
#include "ast.h"


/**
 * @brief Create a new AST node.
 * @returns a pointer to the new node.
 */
struct ast_node* ast_new_node(void) {

    struct ast_node *node = calloc(sizeof(*node), 1);

    if (!node) {
        /* Oh my god! Who's flying this ship? */ ;
    }

    return node;
}


/**
 * @brief Delete an AST node.
 * @param node - Valid AST node.
 */
static void delete_node(struct ast_node *node) {

    if (!node) return;

    /* Fix next_sibling */

    if (node->next_sibling) {

        node->next_sibling->prev_sibling = node->prev_sibling;

    } else if (node->parent) {

        node->parent->last_child = node->prev_sibling;
    }

    /* Fix prev_sibling */

    if (node->prev_sibling) {

        node->prev_sibling->next_sibling = node->next_sibling;

    } else if (node->parent) {

        node->parent->first_child = node->next_sibling;
    }

    /* Fix prev_token */

    if (node->prev_token) {

        node->prev_token->next_token = node->next_token;
    }

    /* Fix next_token */

    if (node->next_token) {

        node->next_token->prev_token = node->prev_token;
    }

    free(node);
}


/**
 * @brief Delete an AST subtree.
 * @param node - Root node.
 */
void ast_delete_node(struct ast_node *node) {

    if (!node) return;

    while (node->first_child) {

        ast_delete_node(node->first_child);
    }

    delete_node(node);
}


/**
 * @brief Compare a pair of text positions lexicographically.
 * @param l1 - First line.
 * @param c1 - First column.
 * @param l2 - Last line.
 * @param c2 - Last column.
 * @returns whether the first position is before the second.
 */
static bool before(int l1, int c1, int l2, int c2) {

    return l1 < l2 || (l1 == l2 && c1 < c2);
}


/**
 * @brief Set text bounds for a compound AST node.
 * @param node - Target node.
 * @param first - First child.
 * @param last - Last child.
 */
void ast_set_text_bounds(struct ast_node *node, struct ast_node *first, struct ast_node *last) {

    if (first)
    if (!node->line_from ||
            (first->line_from &&
                before(first->line_from, first->col_from, node->line_from, node->col_from)))
    {
        node->text_line_from   = first->text_line_from;
        node->text_column_from = first->text_column_from;
        node->prev_token       = first->prev_token;
    }

    if (last)
    if (!node->line_to || (
            last->line_to &&
                before(node->line_to, node->col_to, last->line_to, last->col_to)))
    {
        node->text_line_to   = last->text_line_to;
        node->text_column_to = last->text_column_to;
        node->next_token     = last->next_token;
    }
}


/**
 * @brief Add a child to the front of the child list of an AST node.
 * @param node - Parent node.
 * @param child - Child node.
 *
 * @warning: May have to maintain {prev,next}_tokens manually (if non-member
 *           tokens are at the begining/end)
 */
void ast_push_child_front(struct ast_node *node, struct ast_node *child) {

    child->parent = node;
    child->next_sibling = node->first_child;
    child->prev_sibling = NULL;

    if (node->child_count++) {

        node->first_child->prev_sibling = child;

    } else {

        node->last_child = child;
    }

    node->first_child = child;

    ast_set_text_bounds(node, child, child);
}


/**
 * @brief Add a child to the back of the child list of an AST node.
 * @param node - Parent node.
 * @param child - Child node.
 *
 * @warning: May have to maintain {prev,next}_tokens manually (if non-member
 *           tokens are at the begining/end)
 */
void ast_push_child_back(struct ast_node *node, struct ast_node *child) {

    child->parent = node;
    child->next_sibling = NULL;
    child->prev_sibling = node->last_child;

    if (node->child_count++) {

        node->last_child->next_sibling = child;

    } else {

        node->first_child = child;
    }

    node->last_child = child;

    ast_set_text_bounds(node, child, child);
}


/**
 * @brief Get a specific child of an AST node.
 * @param node - Parent node.
 * @param pos - Position in the child list (0-based).
 * @returns the child node.
 */
struct ast_node* ast_get_child(struct ast_node *node, int pos) {

    if (node->child_count <= pos) return NULL;

    for (node = node->first_child; pos; pos--) {

        node = node->next_sibling;
    }

    return node;
}


/**
 * @brief Add a child to a specific position of the child list of an AST node.
 * @param node - Parent node.
 * @param pos - Position in the child list (0-based).
 * @param child - Child node.
 */
void ast_set_child(struct ast_node *node, int pos, struct ast_node *child) {

    if (node->child_count <= pos) {

        for (; node->child_count < pos; pos--) {

            ast_push_child_back(node, new_tree_node());
        }

        ast_push_child_back(node, child);

        return;
    }

    node = ast_get_child(node, pos);

    child->parent       = node->parent;
    child->prev_sibling = node->prev_sibling;
    child->next_sibling = node->next_sibling;

    ast_delete_node(node);

    /* Fix prev_sibling */

    if (child->prev_sibling) {

        child->prev_sibling->next_sibling = child;

    } else {

        child->parent->first_child = child;
    }

    /* Fix next sibling */

    if (child->next_sibling) {

        child->next_sibling->prev_sibling = child;

    } else {

        child->parent->last_child = child;
    }
}
