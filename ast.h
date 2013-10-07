#ifndef __AST_H__
#define __AST_H__

#include <stddef.h>


typedef struct ast_node {

    /* Text and position */

    char *text;    // pointer to string in input
    int length;    // length of string in input

    int line_from; // starting line in input
    int line_to;   // ending line in input
    int col_from;  // starting column in input
    int col_to;    // ending column in input

    struct ast_node *prev_token; // previous parsed token in input
    struct ast_node *next_token; // next parsed token in input

    /* Data type */

    int data_type;

    /* Node type */

    int node_type;
    int node_subtype;

    /* Syntax tree */

    int child_count;

    struct ast_node *parent;
    struct ast_node *first_child;
    struct ast_node *last_child;
    struct ast_node *prev_sibling;
    struct ast_node *next_sibling;

} *YYSTYPE;


/**
 * @brief Create a new AST node.
 * @returns a pointer to the new node.
 */
struct ast_node* ast_new_node(void);

/**
 * @brief Delete an AST subtree.
 * @param node - Root node.
 */
void ast_delete_node(struct ast_node *node);


/**
 * @brief Add a child to the front of the child list of an AST node.
 * @param node - Parent node.
 * @param child - Child node.
 */
void ast_push_child_front(struct ast_node *node, struct ast_node *child);

/**
 * @brief Add a child to the back of the child list of an AST node.
 * @param node - Parent node.
 * @param child - Child node.
 */
void ast_push_child_back(struct ast_node *node, struct ast_node *child);

/**
 * @brief Get a specific child of an AST node.
 * @param node - Parent node.
 * @param pos - Position in the child list (0-based).
 * @returns the child node.
 */
struct ast_node* ast_get_child(struct ast_node *node, int pos);

/**
 * @brief Add a child to a specific position of the child list of an AST node.
 * @param node - Parent node.
 * @param pos - Position in the child list (0-based).
 * @param child - Child node.
 */
void ast_set_child(struct ast_node *node, int pos, struct ast_node *child);

/**
 * @brief Set text bounds for a compound AST node.
 * @param node - Target node.
 * @param first - First child.
 * @param last - Last child.
 */
void ast_set_text_bounds(struct ast_node *node, struct ast_node *first, struct ast_node *last);


#endif /* __AST_H__ */
