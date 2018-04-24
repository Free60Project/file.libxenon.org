#define MEM_FUSESET_LOC 0x20000020000ULL
#define MEM_FUSESET_SZ 0x10000

#define MEM_1BL_LOC 0x8000020000000000ULL
#define MEM_1BL_SZ 0x8000

#define MEM_NAND_LOC 0xC8000000ULL
#define MEM_NAND_SZ 0x1000000

#include <stdio.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>

volatile void * ioremap(unsigned long long physaddr, unsigned long size)
{
    static int axs_mem_fd = -1;
    unsigned long long page_addr, ofs_addr, reg, pgmask;
    void* reg_mem = NULL;

    /*
     * looks like mmap wants aligned addresses?
     */
    pgmask = getpagesize()-1;
    page_addr = physaddr & ~pgmask;
    ofs_addr  = physaddr & pgmask;

    /*
     * Don't forget O_SYNC, esp. if address is in RAM region.
     * Note: if you do know you'll access in Read Only mode,
     *    pass O_RDONLY to open, and PROT_READ only to mmap
     */
    if (axs_mem_fd == -1) {
        axs_mem_fd = open("/dev/mem", O_RDWR|O_SYNC);
        if (axs_mem_fd < 0) {
                perror("AXS: can't open /dev/mem");
                return NULL;
        }
    }

    /* memory map */
    reg_mem = (void *) mmap64(
        0,
        size + (unsigned long) ofs_addr,
        PROT_READ,
        MAP_SHARED,
        axs_mem_fd,
        page_addr
    );
    if (reg_mem == MAP_FAILED) {
        perror("AXS: mmap error");
        close(axs_mem_fd);
        return NULL;
    }

    reg = (unsigned long) reg_mem + (unsigned long) ofs_addr;
    return (volatile void *)reg;
}

int iounmap(volatile void *start, size_t length)
{
    unsigned long ofs_addr;
    ofs_addr = (unsigned long)start & (getpagesize()-1);

    /* do some cleanup when you're done with it */
    return munmap((unsigned char*)start-ofs_addr, length+ofs_addr);
}


void read64(void * addr, unsigned long long * ptr)
{
   __asm__ (" ld %r3, 0(%r3); std %r3, 0(%r4) ");
}

int main(int argc, char **argv)
{
    int i;
    FILE * fp;
 
    unsigned long long * ptr_u64;
    unsigned char * ptr_u8;
    unsigned char * b;

    printf("dumping fuses...\n");
    ptr_u64 = (unsigned long long *) ioremap(MEM_FUSESET_LOC, MEM_FUSESET_SZ);
    unsigned long long tt;
    fp=fopen("FUSES.TXT", "w");
    for (i = 0; i < 12; ++i) {
      read64((void *) ptr_u64 + i * 0x200, &tt);
      printf("%02x: %016llx\n", i, tt);
      fprintf(fp, "%02x: %016llx\n", i, tt);
    }
    fclose(fp);
    printf("done!\n");

}
