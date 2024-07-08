/**
 * Name: Aaryan Potdar
 * GTID: 903795148
 */

/*  PART 2: A CS-2200 C implementation of the arraylist data structure.
    Implement an array list.
    The methods that are required are all described in the header file. 
    Description for the methods can be found there.

    Hint 1: Review documentation/ man page for malloc, calloc, and realloc.
    Hint 2: Review how an arraylist works.
    Hint 3: You can use GDB if your implentation causes segmentation faults.

    You will submit this file to gradescope.
*/

#include "arraylist.h"


/* @param capacity the intial length of the backing array
 * @return pointer to the newly created struct arraylist
 */
arraylist_t *create_arraylist(uint capacity) {
    arraylist_t *alist = (arraylist_t *)malloc(sizeof(arraylist_t));
    if(!alist) return 0;
    if(alist) {
        alist->backing_array = (char**)malloc(sizeof(char *) * capacity);
        if (!(alist->backing_array)) {
            // free(alist->backing_array); -> no point freeing null pointer 
            free(alist);
            return 0;
        }
        alist->capacity = capacity;
        alist->size = 0;
        
    }
    return alist;
}

/**
 * Add a char * at the specified index of the arraylist.
 * Backing array must be resized as indexing outside of the array will cause a segmentation fault.
 *
 * @param arraylist the arraylist to be modified
 * @param data a pointer to the data that will be added
 * @param index the location that data will be placed in the arraylist
 */
void add_at_index(arraylist_t *arraylist, char *data, int index) {
    if (index < 0 || index > arraylist->size || !data) return;

    if (arraylist->size >= arraylist->capacity) {
        resize(arraylist);
    }

    for (int i = arraylist->size; i > index; i--) {
        arraylist->backing_array[i] = arraylist->backing_array[i - 1];
    }
    arraylist->backing_array[index] = data;
    arraylist-> size++;
}

/**
 * Append a char pointer to the end of the arraylist.
 * Backing array must be resized as indexing outside of the array will cause a segmentation fault
 *
 * @param arraylist the arraylist to be modified
 * @param data a pointer to the data that will be added
 */
void append(arraylist_t *arraylist, char *data) {
    if(!arraylist || ! data) {
        return;
    }
    add_at_index(arraylist, data, arraylist->size);
    return;
}

/**
 * Remove a char * from arraylist at specified index.
 * You do not have to free anything.
 * @param arraylist the arraylist to be modified
 * @param index the location that data will be removed from in the arraylist
 * @return the char * that was removed
 */
char *remove_from_index(arraylist_t *arraylist, int index) {
    if (index < 0 || index > arraylist->size || !arraylist) return NULL;

    char * removed = arraylist->backing_array[index];
    if (index == arraylist->size - 1) {
        // removing last element of element 1 in alist sized 1
        arraylist->backing_array[index] = 0;
        arraylist->size--;
        return removed;

    }
    for (int i = index; i < arraylist->size - 1; i++) {
         arraylist->backing_array[i] = arraylist->backing_array[i + 1];
    }
    arraylist->size--;
    return removed;
}

/**
 * OPTIONAL: This method does not need to be implemented. This is a useful helper method that could be handy
 * if you need to resize your arraylist internally. However, this method is not used ouside of the arraylist.c file.
 * Resize the backing array to hold arraylist->capacity * 2 elements.
 * @param arraylist the arraylist to be resized
 */
void resize(arraylist_t *arraylist) {
    if(!arraylist) return;
    uint newCapacity = arraylist->capacity * 2;
    char ** newBackArray = (char **)realloc(arraylist->backing_array, newCapacity * sizeof(char *));
    if(newBackArray) {
        arraylist->backing_array = newBackArray;
        arraylist->capacity = newCapacity;
    }
}

/**
 * Destroys the arraylist by freeing the backing array and the arraylist.
 * @param arraylist the arraylist to be destroyed
 */
void destroy(arraylist_t *arraylist) {
    free(arraylist->backing_array);
    free(arraylist);
}
